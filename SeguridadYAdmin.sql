---------------------------------------------------------------------
--Primero esquemas para eliminar pemisos directos del objeto transferido
--Socios: Socio, Membresia            (datos personales)
--Operacion: Clase, SesionClase, Reserva (operación diaria)
--Finanzas: Pago                        (datos financieros)
--Personal: Entrenador, Especialidad, EntrenadorEspecialidad
USE Gimnasio;
GO
CREATE SCHEMA Socios AUTHORIZATION dbo;
GO
CREATE SCHEMA Operacion AUTHORIZATION dbo;
GO
CREATE SCHEMA Finanzas AUTHORIZATION dbo;
GO
CREATE SCHEMA Personal AUTHORIZATION dbo;
GO

ALTER SCHEMA Socios TRANSFER dbo.Socio;
ALTER SCHEMA Socios TRANSFER dbo.Membresia;
ALTER SCHEMA Operacion TRANSFER dbo.Clase;
ALTER SCHEMA Operacion TRANSFER dbo.SesionClase;
ALTER SCHEMA Operacion TRANSFER dbo.Reserva;
ALTER SCHEMA Finanzas TRANSFER dbo.Pago;
ALTER SCHEMA Personal TRANSFER dbo.Entrenador;
ALTER SCHEMA Personal TRANSFER dbo.Especialidad;
ALTER SCHEMA Personal TRANSFER dbo.EntrenadorEspecialidad;
GO

--Ver los esquemas efectuados y que tablas les corresponden al, igual que el propietario
SELECT s.name AS Esquema, t.name AS Tabla
FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name IN ('Socios','Operacion','Finanzas','Personal')
ORDER BY s.name, t.name;
GO

SELECT name AS Esquema, USER_NAME(principal_id) AS Propietario
FROM sys.schemas
WHERE name IN ('Socios','Operacion','Finanzas','Personal');
GO

-----------------------------------------------------------------------
--Logins con politicas de contraseña
--Humanos:   CHECK_POLICY = ON, CHECK_EXPIRATION = ON
--Aplicación: CHECK_POLICY = ON, CHECK_EXPIRATION = OFF (rotación planificada)
USE master;
GO
CREATE LOGIN gym_recepcion  WITH PASSWORD = N'Recepc!on',  
  CHECK_POLICY = ON, 
  CHECK_EXPIRATION = ON;
CREATE LOGIN gym_entrenador WITH PASSWORD = N'GymR@t26', 
  CHECK_POLICY = ON, 
  CHECK_EXPIRATION = ON;
CREATE LOGIN gym_finanzas   WITH PASSWORD = N'c0ntabilidAd$',  
  CHECK_POLICY = ON, 
  CHECK_EXPIRATION = ON;
CREATE LOGIN gym_analitica  WITH PASSWORD = N'research3R$', 
  CHECK_POLICY = ON, 
  CHECK_EXPIRATION = ON;
--Cuenta de apliacion o servicio
CREATE LOGIN gym_app        WITH PASSWORD = N'Applicac1A0', 
  CHECK_POLICY = ON, 
  CHECK_EXPIRATION = OFF; --No seria humano la aplicacion entonces se pone OFF
GO

--Consultar las politicas del login de cada uno
SELECT name, is_policy_checked, is_expiration_checked
FROM master.sys.sql_logins
WHERE name LIKE 'gym[_]%'
ORDER BY name;
GO

--Roles por función, nunca permisos de un solo a usuarios
USE Gimnasio;
GO

--Usuarios
CREATE USER gym_recepcion FOR LOGIN gym_recepcion;
CREATE USER gym_entrenador FOR LOGIN gym_entrenador;
CREATE USER gym_finanzas FOR LOGIN gym_finanzas;
CREATE USER gym_analitica FOR LOGIN gym_analitica;
CREATE USER gym_app FOR LOGIN gym_app;
GO

--Roles
CREATE ROLE rol_recepcion;
CREATE ROLE rol_entrenador;
CREATE ROLE rol_finanzas;
CREATE ROLE rol_analitica;
CREATE ROLE rol_app;
GO

--Agregar usuarios a los roles
ALTER ROLE rol_recepcion  ADD MEMBER gym_recepcion;
ALTER ROLE rol_entrenador ADD MEMBER gym_entrenador;
ALTER ROLE rol_finanzas   ADD MEMBER gym_finanzas;
ALTER ROLE rol_analitica  ADD MEMBER gym_analitica;
ALTER ROLE rol_app        ADD MEMBER gym_app;
GO

--Consulta de los login e usuarios dentro del login
SELECT s.name AS login_servidor, u.name AS usuario_bd, s.sid AS sid_servidor, u.sid AS sid_usuario
FROM master.sys.server_principals s
JOIN Gimnasio.sys.database_principals u ON s.sid = u.sid
WHERE s.name LIKE 'gym[_]%';

--Consulta membresia de los roles y usarios
SELECT r.name AS nombre_rol, m.name AS miembro_usuario
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE r.name LIKE 'rol[_]%'
ORDER BY r.name;
GO

----------------------------------------------------------------------
--PERMISOS (mínimo privilegio + defensa en profundidad)
-- rol_recepcion: gestiona socios y reservas, registra pagos; no borra
GRANT SELECT, INSERT, UPDATE ON SCHEMA::Socios TO rol_recepcion;
GRANT SELECT, INSERT, UPDATE ON Operacion.Reserva TO rol_recepcion;
GRANT SELECT ON Operacion.Clase TO rol_recepcion;
GRANT SELECT ON Operacion.SesionClase TO rol_recepcion;
GRANT SELECT, INSERT ON Finanzas.Pago TO rol_recepcion;
DENY  DELETE ON SCHEMA::Socios TO rol_recepcion;
DENY  DELETE ON SCHEMA::Operacion TO rol_recepcion;
DENY  DELETE ON SCHEMA::Finanzas TO rol_recepcion;

-- rol_entrenador: ve sus sesiones y solo nombre del socio (sin DUI/teléfono/correo)
GRANT SELECT ON SCHEMA::Operacion TO rol_entrenador;
GRANT UPDATE ON Operacion.SesionClase (Estado) TO rol_entrenador;
GRANT SELECT ON Socios.Socio (IdSocio, Nombres, Apellidos) TO rol_entrenador;
DENY  DELETE, INSERT ON SCHEMA::Operacion TO rol_entrenador;

-- rol_finanzas: administra pagos y lee membresías; no borra
GRANT SELECT, INSERT, UPDATE ON SCHEMA::Finanzas TO rol_finanzas;
GRANT SELECT ON Socios.Membresia TO rol_finanzas;
DENY  DELETE ON SCHEMA::Finanzas TO rol_finanzas;

-- rol_analitica (Power BI): solo lectura, sin datos personales sensibles
GRANT SELECT ON SCHEMA::Socios TO rol_analitica;
GRANT SELECT ON SCHEMA::Operacion TO rol_analitica;
GRANT SELECT ON SCHEMA::Finanzas TO rol_analitica;
GRANT SELECT ON SCHEMA::Personal TO rol_analitica;
DENY  SELECT ON Socios.Socio (Dui, Telefono, Correo) TO rol_analitica;
DENY  SELECT ON Personal.Entrenador (Dui, Telefono, Correo) TO rol_analitica;

-- rol_app: CRUD acotado; nunca borra ni altera estructura
GRANT SELECT, INSERT, UPDATE ON SCHEMA::Socios TO rol_app;
GRANT SELECT, INSERT, UPDATE ON Operacion.Reserva TO rol_app;
GRANT SELECT ON Operacion.Clase TO rol_app;
GRANT SELECT ON Operacion.SesionClase TO rol_app;
GRANT SELECT, INSERT ON Finanzas.Pago TO rol_app;
DENY  DELETE ON SCHEMA::Socios TO rol_app;
DENY  DELETE ON SCHEMA::Operacion TO rol_app;
DENY  DELETE ON SCHEMA::Finanzas TO rol_app;
DENY  ALTER  ON SCHEMA::Socios TO rol_app;
DENY  ALTER  ON SCHEMA::Operacion TO rol_app;
DENY  ALTER  ON SCHEMA::Finanzas TO rol_app;
DENY  ALTER  ON SCHEMA::Personal TO rol_app;
GO

--Consulta de los permisos registrados
SELECT pr.name AS receptor, pe.permission_name AS permiso, pe.state_desc AS estado,
       pe.class_desc AS ambito,
       CASE pe.class WHEN 3 THEN SCHEMA_NAME(pe.major_id)
            ELSE OBJECT_SCHEMA_NAME(pe.major_id) + '.' + OBJECT_NAME(pe.major_id) END AS objeto,
       COL_NAME(pe.major_id, pe.minor_id) AS columna
FROM sys.database_permissions pe
JOIN sys.database_principals pr ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name LIKE 'rol[_]%'
ORDER BY pr.name, pe.state_desc, pe.permission_name;
GO

--Antes, en PowerShell:  docker exec sqlserver-2025 mkdir -p /audit/Gimnasio
--Si no se puede iniciar como administrador o desde docker desktop
--MAX_FILES = 5: si se llena la carpeta, la auditoría no inicia.
USE master;
GO
CREATE SERVER AUDIT AuditoriaGimnasio
TO FILE (
  FILEPATH = N'/audit/Gimnasio/', 
  MAXSIZE = 10 MB, 
  MAX_FILES = 5)
WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
GO

--Activar la auditoria de servidor
ALTER SERVER AUDIT AuditoriaGimnasio WITH (STATE = ON);
GO

-- (Extra) Intentos fallidos de inicio de sesión: evidencia de la política de contraseñas
CREATE SERVER AUDIT SPECIFICATION AuditoriaLoginsGimnasio
FOR SERVER AUDIT AuditoriaGimnasio
ADD (FAILED_LOGIN_GROUP)
WITH (STATE = ON);
GO

USE Gimnasio;
GO
CREATE DATABASE AUDIT SPECIFICATION AuditoriaGimnasioDB
FOR SERVER AUDIT AuditoriaGimnasio
ADD (SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Finanzas BY public),
ADD (SELECT, INSERT, UPDATE, DELETE ON OBJECT::Socios.Socio BY public)
WITH (STATE = ON);
GO

--Consulta su estado y acciones auditadas
SELECT name, status_desc, audit_file_path FROM sys.dm_server_audit_status;

SELECT audit_action_name, class_desc, OBJECT_NAME(major_id) AS objeto
FROM sys.database_audit_specification_details
ORDER BY audit_action_name;
GO

/* ---------------------------------------------------------------------
   DATOS PARA PROBAR (al momento de hacerlo no teniamos datos)
   --------------------------------------------------------------------- */
USE Gimnasio;
GO
IF NOT EXISTS (SELECT 1 FROM Socios.Membresia)
    INSERT INTO Socios.Membresia (Nombre, Descripcion, Precio, Duracion)
    VALUES ('Mensual', 'Acceso total', 25.00, 30);
GO

---------------------------------------------------------------------
--PRUEBAS CON EXECUTE AS diferentes usuarios y siempre cerrar con REVERT.
--Salida de denegado por defecto: analítica no puede insertar (Error 229)
EXECUTE AS USER = 'gym_analitica';
INSERT INTO Socios.Membresia (Nombre, Precio, Duracion) VALUES ('Intruso', 1, 1);
REVERT;
GO

-- Salida de analítica no puede leer datos personales (Error 230); sí columnas no sensibles
EXECUTE AS USER = 'gym_analitica';
SELECT Dui FROM Socios.Socio;                         -- Error 230
SELECT IdSocio, Nombres, FechaRegistro FROM Socios.Socio;  -- SELECT en objetos permitida
REVERT;
GO

--Recepción: puede insertar/actualizar socios; no puede borrar (Error 229)
EXECUTE AS USER = 'gym_recepcion';
INSERT INTO Socios.Socio (Nombres, Apellidos, Dui, FechaRegistro, IdMembresia)
VALUES ('Ana', 'Pérez', '01234567-8', GETDATE(), (SELECT TOP 1 IdMembresia FROM Socios.Membresia)); --INSERT permitido
UPDATE Socios.Socio SET Telefono = '7000-0000' WHERE Dui = '01234567-8'; --UPDATE permitido
DELETE FROM Socios.Socio WHERE Dui = '01234567-8';    -- Error 229, permiso denegado
REVERT;
GO

--Entrenador: ve nombre del socio pero no el DUI (Error 230)
EXECUTE AS USER = 'gym_entrenador';
SELECT IdSocio, Nombres, Apellidos FROM Socios.Socio;  -- SELECT en objetos permitido
SELECT Dui FROM Socios.Socio;                          -- Error 230, permiso denegado
REVERT;
GO

--Finanzas: registra pago; no puede borrar (Error 229)
EXECUTE AS USER = 'gym_finanzas';
INSERT INTO Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia)
VALUES (25.00, GETDATE(), 'Efectivo', 'Pagado',
        (SELECT TOP 1 IdMembresia FROM Socios.Membresia)); --INSERT permitido
DELETE FROM Finanzas.Pago;                             -- Error 229, permiso denegado
REVERT;
GO

--App: no puede alterar estructura (Error 229)
EXECUTE AS USER = 'gym_app';
ALTER TABLE Socios.Socio ADD Prueba INT NULL;          -- Error 229, permiso denegado
REVERT;
GO

--Permisos efectivos
EXECUTE AS USER = 'gym_app';
SELECT 'gym_app' AS usuario, entity_name, permission_name
FROM fn_my_permissions('Socios.Socio', 'OBJECT');
REVERT;
GO
EXECUTE AS USER = 'gym_analitica';
SELECT 'gym_analitica' AS usuario, entity_name, permission_name
FROM fn_my_permissions('Socios.Socio', 'OBJECT');
REVERT;
GO

SELECT USER_NAME() AS debe_ser_dbo; --TIENE que ser dbo
GO

--------------------------------------------------------
--CONSULTA DE LOGS DE AUDITORÍA
--event_time está en UTC; en El Salvador restar 6 horas.
USE master;
GO

SELECT event_time, action_id, succeeded, server_principal_name,
       database_principal_name, database_name, schema_name, object_name, statement
FROM sys.fn_get_audit_file(N'/audit/Gimnasio/*.sqlaudit', DEFAULT, DEFAULT)
WHERE database_name = N'Gimnasio' OR action_id = 'LGIF'
ORDER BY event_time DESC;
GO

-- Intentos fallidos de login: provocar uno conectándose a SSMS con mala clave
-- y luego consultar:
EXEC sys.xp_readerrorlog 0, 1, 'Login failed';
GO

/* ---------------------------------------------------------------------
   LIMPIEZA (solo si necesitan repetir; destruir la evidencia de auditoria)
   ---------------------------------------------------------------------
-- USE Gimnasio;
-- ALTER DATABASE AUDIT SPECIFICATION AuditoriaGimnasioDB WITH (STATE = OFF);
-- DROP DATABASE AUDIT SPECIFICATION AuditoriaGimnasioDB;
-- USE master;
-- ALTER SERVER AUDIT SPECIFICATION AuditoriaLoginsGimnasio WITH (STATE = OFF);
-- DROP SERVER AUDIT SPECIFICATION AuditoriaLoginsGimnasio;
-- ALTER SERVER AUDIT AuditoriaGimnasio WITH (STATE = OFF);
-- DROP SERVER AUDIT AuditoriaGimnasio;
-- USE Gimnasio;
-- DROP USER IF EXISTS gym_recepcion, gym_entrenador, gym_finanzas, gym_analitica, gym_app;
-- DROP ROLE IF EXISTS rol_recepcion, rol_entrenador, rol_finanzas, rol_analitica, rol_app;
-- USE master;
-- DROP LOGIN gym_recepcion; DROP LOGIN gym_entrenador; DROP LOGIN gym_finanzas;
-- DROP LOGIN gym_analitica; DROP LOGIN gym_app;
   --------------------------------------------------------------------- */

USE Gimnasio;
ALTER DATABASE AUDIT SPECIFICATION AuditoriaGimnasioDB WITH (STATE = OFF);
DROP DATABASE AUDIT SPECIFICATION AuditoriaGimnasioDB;
USE master;
ALTER SERVER AUDIT SPECIFICATION AuditoriaLoginsGimnasio WITH (STATE = OFF);
DROP SERVER AUDIT SPECIFICATION AuditoriaLoginsGimnasio;
ALTER SERVER AUDIT AuditoriaGimnasio WITH (STATE = OFF);
DROP SERVER AUDIT AuditoriaGimnasio;
USE Gimnasio;
DROP USER IF EXISTS gym_recepcion;
DROP USER IF EXISTS gym_entrenador;
DROP USER IF EXISTS gym_finanzas;
DROP USER IF EXISTS gym_analitica;
DROP USER IF EXISTS gym_app;
DROP ROLE IF EXISTS rol_recepcion;
DROP ROLE IF EXISTS rol_entrenador;
DROP ROLE IF EXISTS rol_finanzas;
DROP ROLE IF EXISTS rol_analitica;
DROP ROLE IF EXISTS rol_app;
GO
DROP ROLE IF EXISTS rol_recepcion;
DROP ROLE IF EXISTS rol_entrenador;
DROP ROLE IF EXISTS rol_finanzas;
DROP ROLE IF EXISTS rol_analitica;
DROP ROLE IF EXISTS rol_app;
GO
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'gym_recepcion')  DROP LOGIN gym_recepcion;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'gym_entrenador') DROP LOGIN gym_entrenador;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'gym_finanzas')   DROP LOGIN gym_finanzas;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'gym_analitica')  DROP LOGIN gym_analitica;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'gym_app')        DROP LOGIN gym_app;
GO