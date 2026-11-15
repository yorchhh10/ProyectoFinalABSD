/* =====================================================================
   IMPORTANTE: ejecutar la sección 2-3 ANTES de crear los jobs (sección 4),
   porque los respaldos de prueba cambian la base diferencial y la cadena de logs.
   ===================================================================== */

/* ---------------------------------------------------------------------
   0. CARPETA DE RESPALDOS (PowerShell, no SSMS)
   docker exec sqlserver-2025 mkdir -p /backup/Gimnasio
   docker exec sqlserver-2025 ls -d /backup/Gimnasio
   --------------------------------------------------------------------- */

/* ---------------------------------------------------------------------
   OBJETIVOS (se justifican en el informe)
   RPO = 15 min  -> respaldo de log cada 15 min
   RTO = 30 min  -> restaurar full + diferencial + logs
   WRT = 10 min  -> verificar y reabrir el servicio
   MTD = 45 min  -> RTO + WRT = 40 min <= 45 min
   --------------------------------------------------------------------- */

/* ---------------------------------------------------------------------
   1. MODELO DE RECUPERACIÓN FULL
   --------------------------------------------------------------------- */
USE master;
IF DB_ID(N'Gimnasio') IS NULL
    THROW 50001, N'La base Gimnasio no existe.', 1;
EXEC(N'ALTER DATABASE Gimnasio SET RECOVERY FULL;');
SELECT name, recovery_model_desc, state_desc
FROM sys.databases WHERE name = N'Gimnasio';
GO

/* ---------------------------------------------------------------------
   2. PRUEBA MANUAL DE LA CADENA (Full -> Diferencial -> Log)
   --------------------------------------------------------------------- */
-- 2.1 Estado inicial
USE Gimnasio;
SELECT 'Pago' AS Tabla, COUNT(*) AS Filas FROM Finanzas.Pago
UNION ALL SELECT 'Socio',   COUNT(*) FROM Socios.Socio
UNION ALL SELECT 'Reserva', COUNT(*) FROM Operacion.Reserva;
GO

-- 2.2 Respaldo completo
USE master;
BACKUP DATABASE Gimnasio
TO DISK = N'/backup/Gimnasio/Gimnasio_prueba_full.bak'
WITH INIT, CHECKSUM, COMPRESSION, NAME = N'Prueba completo Gimnasio';
GO

-- 2.3 Cambios que quedarán en el diferencial (2 pagos marcados)
USE Gimnasio;
INSERT INTO Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia)
SELECT TOP (2) 20.00, '20261114', N'PRUEBA-DIF', 'Pagado', IdMembresia
FROM Socios.Membresia ORDER BY IdMembresia;
GO

-- 2.4 Respaldo diferencial
USE master;
BACKUP DATABASE Gimnasio
TO DISK = N'/backup/Gimnasio/Gimnasio_prueba_diff.bak'
WITH DIFFERENTIAL, INIT, CHECKSUM, COMPRESSION, NAME = N'Prueba diferencial Gimnasio';
GO

-- 2.5 Cambio que quedará solo en el log (1 pago marcado)
USE Gimnasio;
INSERT INTO Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia)
SELECT TOP (1) 30.00, '20261114', N'PRUEBA-LOG', 'Pagado', IdMembresia
FROM Socios.Membresia ORDER BY IdMembresia;
GO

-- 2.6 Respaldo del log
USE master;
BACKUP LOG Gimnasio
TO DISK = N'/backup/Gimnasio/Gimnasio_prueba_log.trn'
WITH INIT, CHECKSUM, COMPRESSION, NAME = N'Prueba log Gimnasio';
GO

-- 2.7 Dato SIN respaldo (representa la pérdida medida por el RPO)
USE Gimnasio;
INSERT INTO Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia)
SELECT TOP (1) 45.00, '20261114', N'PRUEBA-PERDIDA', 'Pagado', IdMembresia
FROM Socios.Membresia ORDER BY IdMembresia;
SELECT Metodo, COUNT(*) AS Filas FROM Finanzas.Pago
WHERE Metodo LIKE N'PRUEBA-%' GROUP BY Metodo;   -- DIF 2, LOG 1, PERDIDA 1
GO

-- 2.8 Verificar que los tres respaldos son legibles
USE master;
RESTORE VERIFYONLY FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_full.bak' WITH CHECKSUM;
RESTORE VERIFYONLY FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_diff.bak' WITH CHECKSUM;
RESTORE VERIFYONLY FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_log.trn'  WITH CHECKSUM;
GO

/* ---------------------------------------------------------------------
   3. RESTAURACIÓN (a una copia, sin tocar la base en uso)
   Iniciar cronómetro aquí; detenerlo al terminar 3.4 (mide el RTO real).
   --------------------------------------------------------------------- */
-- 3.1 Nombres lógicos de archivos (esperados: Gimnasio y Gimnasio_log)
USE master;
RESTORE FILELISTONLY FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_full.bak';
GO

-- 3.2 Completo (NORECOVERY: la base queda en RESTORING)
USE master;
IF DB_ID(N'Gimnasio_Restore') IS NOT NULL
    THROW 50010, N'Gimnasio_Restore ya existe. Elimínela antes de repetir la prueba.', 1;
RESTORE DATABASE Gimnasio_Restore
FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_full.bak'
WITH MOVE N'Gimnasio'     TO N'/var/opt/mssql/data/Gimnasio_Restore.mdf',
     MOVE N'Gimnasio_log' TO N'/var/opt/mssql/data/Gimnasio_Restore_log.ldf',
     NORECOVERY;
SELECT name, state_desc FROM sys.databases WHERE name = N'Gimnasio_Restore';
GO

-- 3.3 Diferencial (sigue en RESTORING)
RESTORE DATABASE Gimnasio_Restore
FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_diff.bak'
WITH NORECOVERY;
SELECT name, state_desc FROM sys.databases WHERE name = N'Gimnasio_Restore';
GO

-- 3.4 Log (RECOVERY: la base pasa a ONLINE)
RESTORE LOG Gimnasio_Restore
FROM DISK = N'/backup/Gimnasio/Gimnasio_prueba_log.trn'
WITH RECOVERY;
SELECT name, state_desc FROM sys.databases WHERE name = N'Gimnasio_Restore';
GO

-- 3.5 Comprobar datos: la copia debe tener DIF=2, LOG=1 y NO tener PERDIDA
SELECT 'Original' AS Base, Metodo, COUNT(*) AS Filas
FROM Gimnasio.Finanzas.Pago WHERE Metodo LIKE N'PRUEBA-%' GROUP BY Metodo
UNION ALL
SELECT 'Restaurada', Metodo, COUNT(*)
FROM Gimnasio_Restore.Finanzas.Pago WHERE Metodo LIKE N'PRUEBA-%' GROUP BY Metodo
ORDER BY Base, Metodo;
GO

-- 3.6 Limpieza de la prueba
DELETE FROM Gimnasio.Finanzas.Pago WHERE Metodo LIKE N'PRUEBA-%';
USE master;
DROP DATABASE Gimnasio_Restore;
GO

/* ---------------------------------------------------------------------
   4. RESPALDO AUTOMÁTICO (SQL Agent)
   Calendario (hora de El Salvador, UTC-6):
     Completo      domingo 02:00
     Diferencial   lunes a sábado 02:00
     Log           cada 15 minutos
   Agent debe estar Running. Si el servidor está en UTC (desfase 0) 02:00 SV
   = 08:00 UTC; el script lo calcula solo.
   --------------------------------------------------------------------- */
USE msdb;
CREATE USER user_backup_msdb FOR LOGIN gym_backup;
ALTER ROLE SQLAgentUserRole ADD MEMBER user_backup_msdb;

USE master;
SELECT servicename, status_desc,
       DATEPART(TZOFFSET, SYSDATETIMEOFFSET()) AS desfase_utc_minutos
FROM sys.dm_server_services
WHERE servicename LIKE N'SQL Server Agent%';
GO

USE msdb;
IF EXISTS (SELECT 1 FROM dbo.sysjobs WHERE name LIKE N'Gimnasio - Respaldo%')
    THROW 50020, N'Los jobs de Gimnasio ya existen. No los cree otra vez.', 1;

DECLARE @desfase int = DATEPART(TZOFFSET, SYSDATETIMEOFFSET());
DECLARE @hora int = CASE @desfase WHEN 0 THEN 80000 WHEN -360 THEN 20000 END;
IF @hora IS NULL
    THROW 50021, N'Desfase inesperado: ajuste @hora a mano (02:00 de El Salvador).', 1;

DECLARE @cmdFull nvarchar(max) = N'DECLARE @f nvarchar(260) = N''/backup/Gimnasio/Gimnasio_full_'' + FORMAT(SYSDATETIME(), ''yyyyMMdd_HHmm'') + N''.bak''; BACKUP DATABASE Gimnasio TO DISK = @f WITH INIT, CHECKSUM, COMPRESSION, NAME = N''Full Gimnasio (job)'';';
DECLARE @cmdDiff nvarchar(max) = N'DECLARE @f nvarchar(260) = N''/backup/Gimnasio/Gimnasio_diff_'' + FORMAT(SYSDATETIME(), ''yyyyMMdd_HHmm'') + N''.bak''; BACKUP DATABASE Gimnasio TO DISK = @f WITH DIFFERENTIAL, INIT, CHECKSUM, COMPRESSION, NAME = N''Diferencial Gimnasio (job)'';';
DECLARE @cmdLog  nvarchar(max) = N'DECLARE @f nvarchar(260) = N''/backup/Gimnasio/Gimnasio_log_'' + FORMAT(SYSDATETIME(), ''yyyyMMdd_HHmm'') + N''.trn''; BACKUP LOG Gimnasio TO DISK = @f WITH INIT, CHECKSUM, COMPRESSION, NAME = N''Log Gimnasio (job)'';';

-- Completo semanal (domingo)
EXEC dbo.sp_add_job @job_name = N'Gimnasio - Respaldo completo semanal', @owner_login_name = N'gym_backup';
EXEC dbo.sp_add_jobstep @job_name = N'Gimnasio - Respaldo completo semanal',
     @step_name = N'Respaldo completo', @subsystem = N'TSQL',
     @database_name = N'master', @command = @cmdFull;
EXEC dbo.sp_add_jobserver @job_name = N'Gimnasio - Respaldo completo semanal';
EXEC dbo.sp_add_schedule @schedule_name = N'Gimnasio_full_dom_02h_SV',
     @freq_type = 8, @freq_interval = 1, @freq_recurrence_factor = 1,
     @active_start_time = @hora;
EXEC dbo.sp_attach_schedule @job_name = N'Gimnasio - Respaldo completo semanal',
     @schedule_name = N'Gimnasio_full_dom_02h_SV';

-- Diferencial diario (lunes a sábado; máscara 2+4+8+16+32+64 = 126)
EXEC dbo.sp_add_job @job_name = N'Gimnasio - Respaldo diferencial diario', @owner_login_name = N'gym_backup';
EXEC dbo.sp_add_jobstep @job_name = N'Gimnasio - Respaldo diferencial diario',
     @step_name = N'Respaldo diferencial', @subsystem = N'TSQL',
     @database_name = N'master', @command = @cmdDiff;
EXEC dbo.sp_add_jobserver @job_name = N'Gimnasio - Respaldo diferencial diario';
EXEC dbo.sp_add_schedule @schedule_name = N'Gimnasio_diff_lunsab_02h_SV',
     @freq_type = 8, @freq_interval = 126, @freq_recurrence_factor = 1,
     @active_start_time = @hora;
EXEC dbo.sp_attach_schedule @job_name = N'Gimnasio - Respaldo diferencial diario',
     @schedule_name = N'Gimnasio_diff_lunsab_02h_SV';

-- Log cada 15 minutos
EXEC dbo.sp_add_job @job_name = N'Gimnasio - Respaldo de log 15 min', @owner_login_name = N'gym_backup';
EXEC dbo.sp_add_jobstep @job_name = N'Gimnasio - Respaldo de log 15 min',
     @step_name = N'Respaldo de log', @subsystem = N'TSQL',
     @database_name = N'master', @command = @cmdLog;
EXEC dbo.sp_add_jobserver @job_name = N'Gimnasio - Respaldo de log 15 min';
EXEC dbo.sp_add_schedule @schedule_name = N'Gimnasio_log_cada_15min',
     @freq_type = 4, @freq_interval = 1,
     @freq_subday_type = 4, @freq_subday_interval = 15,
     @active_start_time = 0, @active_end_time = 235959;
EXEC dbo.sp_attach_schedule @job_name = N'Gimnasio - Respaldo de log 15 min',
     @schedule_name = N'Gimnasio_log_cada_15min';

SELECT name, enabled FROM dbo.sysjobs WHERE name LIKE N'Gimnasio - Respaldo%';
SELECT name, freq_type, freq_interval, freq_subday_type, freq_subday_interval, active_start_time
FROM dbo.sysschedules WHERE name LIKE N'Gimnasio[_]%';
GO

-- Ejecutar ahora para tener evidencia (completo primero: inicia la cadena real)
EXEC msdb.dbo.sp_start_job @job_name = N'Gimnasio - Respaldo completo semanal';
WAITFOR DELAY '00:00:20';
EXEC msdb.dbo.sp_start_job @job_name = N'Gimnasio - Respaldo diferencial diario';
WAITFOR DELAY '00:00:20';
EXEC msdb.dbo.sp_start_job @job_name = N'Gimnasio - Respaldo de log 15 min';
GO

/* ---------------------------------------------------------------------
   5. EVIDENCIAS
   --------------------------------------------------------------------- */
-- 5.1 Resultado de los jobs (hora del servidor)
SELECT TOP (10) j.name AS trabajo,
       msdb.dbo.agent_datetime(h.run_date, h.run_time) AS inicio,
       CASE h.run_status WHEN 1 THEN N'Correcto' WHEN 0 THEN N'Falló'
            ELSE N'Revisar historial' END AS resultado
FROM msdb.dbo.sysjobhistory AS h
JOIN msdb.dbo.sysjobs AS j ON j.job_id = h.job_id
WHERE j.name LIKE N'Gimnasio - Respaldo%' AND h.step_id = 0
ORDER BY h.instance_id DESC;
GO

-- 5.2 Historial de respaldos (también sirve para calibrar el dimensionamiento)
SELECT TOP (20) bs.database_name,
       CASE bs.type WHEN 'D' THEN 'Completo' WHEN 'I' THEN 'Diferencial'
            WHEN 'L' THEN 'Log' END AS tipo,
       bs.backup_start_date, bs.backup_finish_date,
       CAST(bs.backup_size / 1048576.0 AS decimal(10,2)) AS MB,
       CAST(bs.compressed_backup_size / 1048576.0 AS decimal(10,2)) AS MB_comprimido,
       bmf.physical_device_name
FROM msdb.dbo.backupset AS bs
JOIN msdb.dbo.backupmediafamily AS bmf ON bmf.media_set_id = bs.media_set_id
WHERE bs.database_name = N'Gimnasio'
ORDER BY bs.backup_start_date DESC;
GO

-- 5.3 Operaciones de respaldo/restauración en la auditoría (BACKUP_RESTORE_GROUP)
SELECT event_time, server_principal_name, action_id, succeeded, statement
FROM sys.fn_get_audit_file(N'/audit/Gimnasio/*.sqlaudit', DEFAULT, DEFAULT)
WHERE statement LIKE N'%BACKUP%' OR statement LIKE N'%RESTORE%'
ORDER BY event_time DESC;
GO

-- 5.4 Archivos en disco (PowerShell):
--     docker exec sqlserver-2025 ls -lh /backup/Gimnasio

/* ---------------------------------------------------------------------
   6. PROCEDIMIENTO ANTE UN FALLO REAL (plantilla; ajustar nombres de archivo)
   1) Detener la aplicación (gym_app) y anotar la hora de la falla.
   2) Si el log sigue accesible, respaldo de cola para perder ~0 datos:
        BACKUP LOG Gimnasio TO DISK = N'/backup/Gimnasio/Gimnasio_cola.trn'
        WITH NO_TRUNCATE, CHECKSUM;
   3) Restaurar el último completo:
        RESTORE DATABASE Gimnasio FROM DISK = N'.../Gimnasio_full_AAAAMMDD_HHMM.bak'
        WITH REPLACE, NORECOVERY;
   4) Restaurar el último diferencial (WITH NORECOVERY).
   5) Restaurar los logs en orden, y la cola al final:
        RESTORE LOG Gimnasio FROM DISK = N'...' WITH NORECOVERY;   -- cada log
        RESTORE LOG Gimnasio FROM DISK = N'.../Gimnasio_cola.trn' WITH RECOVERY;
   6) Verificar conteos (sección 2.1), reactivar la aplicación y crear un
      completo nuevo.
   --------------------------------------------------------------------- */