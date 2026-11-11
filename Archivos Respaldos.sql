USE master;
GO
SET NOCOUNT ON;

-- Ejecutar primero COMPLETO, después DIFERENCIAL y finalmente LOG.
DECLARE @Tipo varchar(12) = 'COMPLETO';

IF DB_ID(N'Gimnasio') IS NULL
    THROW 50001, 'No existe Gimnasio.', 1;
IF @Tipo NOT IN ('COMPLETO', 'DIFERENCIAL', 'LOG')
    THROW 50002, 'Tipo no válido.', 1;

IF (SELECT recovery_model_desc FROM sys.databases
    WHERE name = N'Gimnasio') <> N'FULL'
BEGIN
    IF @Tipo <> 'COMPLETO'
        THROW 50003, 'Ejecute primero COMPLETO para iniciar el plan.', 1;
    ALTER DATABASE Gimnasio SET RECOVERY FULL;
END;

DECLARE @Archivo nvarchar(4000) =
    N'/var/opt/mssql/backup/Gimnasio_' + @Tipo + N'_'
    + CONVERT(char(8), GETDATE(), 112) + N'_'
    + REPLACE(CONVERT(char(8), GETDATE(), 108), ':', '')
    + N'_' + CONVERT(nvarchar(36), NEWID())
    + CASE WHEN @Tipo = 'LOG' THEN N'.trn' ELSE N'.bak' END;
DECLARE @Inicio datetime2 = SYSDATETIME();

-- Ante un error, se detiene este lote; no se oculta el error.
BEGIN TRY
    IF @Tipo = 'COMPLETO'
        BACKUP DATABASE Gimnasio TO DISK = @Archivo
        WITH CHECKSUM, STATS = 10;

    IF @Tipo = 'DIFERENCIAL'
        BACKUP DATABASE Gimnasio TO DISK = @Archivo
        WITH DIFFERENTIAL, CHECKSUM, STATS = 10;

    IF @Tipo = 'LOG'
        BACKUP LOG Gimnasio TO DISK = @Archivo
        WITH CHECKSUM, STATS = 10;

    RESTORE VERIFYONLY FROM DISK = @Archivo WITH CHECKSUM;

    SELECT @Tipo AS TipoRespaldo, @Archivo AS ArchivoGenerado,
           @Inicio AS Inicio, SYSDATETIME() AS Fin,
           DATEDIFF(SECOND, @Inicio, SYSDATETIME()) AS Segundos,
           N'Respaldo generado y verificado' AS Resultado;
END TRY
BEGIN CATCH
    THROW;
END CATCH;

SELECT TOP (50)
    bs.backup_set_id,
    CASE bs.type WHEN 'D' THEN 'Completo'
                 WHEN 'I' THEN 'Diferencial'
                 WHEN 'L' THEN 'Registro' ELSE bs.type END AS Tipo,
    bs.backup_start_date AS Inicio,
    bs.backup_finish_date AS Fin,
    CAST(bs.compressed_backup_size / 1048576.0
         AS decimal(18,3)) AS TamanoRespaldoMB,
    bs.first_lsn, bs.last_lsn, bs.checkpoint_lsn,
    bs.database_backup_lsn,
    bs.has_backup_checksums AS TieneChecksum,
    bmf.physical_device_name AS Archivo
FROM msdb.dbo.backupset AS bs
JOIN msdb.dbo.backupmediafamily AS bmf
    ON bmf.media_set_id = bs.media_set_id
WHERE bs.database_name = N'Gimnasio'
ORDER BY bs.backup_finish_date DESC;
GO