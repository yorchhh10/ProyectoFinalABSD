USE Gimnasio;
GO
SET NOCOUNT ON;

-- Supuestos de ejemplo, no mediciones reales de crecimiento.
DECLARE @CrecimientoMensual float = 0.10;
DECLARE @Meses int = 12;
DECLARE @Margen float = 0.20;

;WITH Espacio AS (
    SELECT s.name AS Esquema, t.name AS Tabla,
        SUM(CASE WHEN p.index_id IN (0,1)
                 THEN p.row_count ELSE 0 END) AS FilasAproximadas,
        SUM(CASE WHEN p.index_id IN (0,1)
                 THEN p.in_row_data_page_count + p.lob_used_page_count
                    + p.row_overflow_used_page_count
                 ELSE 0 END) AS PaginasDatos,
        SUM(p.used_page_count) AS PaginasUsadas,
        SUM(p.reserved_page_count) AS PaginasReservadas
    FROM sys.tables AS t
    JOIN sys.schemas AS s ON s.schema_id = t.schema_id
    JOIN sys.dm_db_partition_stats AS p ON p.object_id = t.object_id
    WHERE t.is_ms_shipped = 0
    GROUP BY s.name, t.name
)
SELECT Esquema, Tabla, FilasAproximadas,
    CAST(PaginasDatos * 8.0 / 1024 AS decimal(18,3)) AS DatosMB,
    CAST((PaginasUsadas - PaginasDatos) * 8.0 / 1024
         AS decimal(18,3)) AS IndicesYEstructurasMB,
    CAST(PaginasUsadas * 8.0 / 1024 AS decimal(18,3)) AS TotalUsadoMB,
    CAST(PaginasReservadas * 8.0 / 1024
         AS decimal(18,3)) AS ReservadoMB,
    CAST(PaginasUsadas * 8.0 / 1024
         * POWER(1 + @CrecimientoMensual, @Meses) * (1 + @Margen)
         AS decimal(18,3)) AS ProyeccionConMargenMB
FROM Espacio ORDER BY TotalUsadoMB DESC;

-- Desglose por índice. Un clustered contiene también datos.
SELECT s.name AS Esquema, t.name AS Tabla,
    COALESCE(i.name, N'(Heap)') AS Indice, i.type_desc AS Tipo,
    CAST(SUM(p.used_page_count) * 8.0 / 1024
         AS decimal(18,3)) AS UsadoMB
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
JOIN sys.indexes AS i ON i.object_id = t.object_id
JOIN sys.dm_db_partition_stats AS p
    ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE t.is_ms_shipped = 0
GROUP BY s.name, t.name, i.name, i.type_desc
ORDER BY UsadoMB DESC;

-- Tamaño físico asignado, incluyendo espacio interno libre.
SELECT name AS NombreLogico, type_desc AS Tipo, physical_name AS Ruta,
    CAST(size * 8.0 / 1024 AS decimal(18,3)) AS AsignadoMB
FROM sys.database_files;

SELECT
    CAST(total_log_size_in_bytes / 1048576.0
         AS decimal(18,3)) AS LogTotalMB,
    CAST(used_log_space_in_bytes / 1048576.0
         AS decimal(18,3)) AS LogUsadoMB,
    CAST(used_log_space_in_percent
         AS decimal(10,2)) AS PorcentajeLogUsado
FROM sys.dm_db_log_space_usage;

-- Promedios de respaldos observados en los últimos 28 días.
-- Ensayos consecutivos NO representan un mes de operación.
SELECT CASE type WHEN 'D' THEN 'Completo'
                 WHEN 'I' THEN 'Diferencial'
                 WHEN 'L' THEN 'Registro' END AS Tipo,
    COUNT(*) AS Cantidad,
    CAST(AVG(CAST(compressed_backup_size AS decimal(28,2)))
         / 1048576.0 AS decimal(18,3)) AS PromedioMB
FROM msdb.dbo.backupset
WHERE database_name = N'Gimnasio'
  AND type IN ('D','I','L')
  AND is_copy_only = 0
  AND backup_finish_date >= DATEADD(DAY, -28, GETDATE())
GROUP BY type;
GO