USE Gimnasio;
GO

-- CONSULTA 1: Ocupación y cupos disponibles por sesión.
--Permite a recepción identificar sesiones llenas o con espacio.
--Las sesiones sin reservas confirmadas aparecen con ocupación 0.

SELECT
    s.IdSesion,
    c.Nombre AS Clase,
    s.Fecha,
    s.HoraInicio,
    s.Estado AS EstadoSesion,
    s.CupoMaximo,
    COUNT(r.IdReserva) AS ReservasConfirmadas,
    s.CupoMaximo - COUNT(r.IdReserva) AS CuposDisponibles,
    CAST(
        100.0 * COUNT(r.IdReserva) / NULLIF(s.CupoMaximo, 0)
        AS decimal(10, 2)
    ) AS PorcentajeOcupacion
FROM dbo.SesionClase AS s
JOIN dbo.Clase AS c
    ON c.IdClase = s.IdClase
LEFT JOIN dbo.Reserva AS r
    ON r.IdSesion = s.IdSesion
   AND r.Estado = 'Confirmada'
GROUP BY
    s.IdSesion, c.Nombre, s.Fecha, s.HoraInicio, s.Estado, s.CupoMaximo
ORDER BY s.Fecha, s.HoraInicio, s.IdSesion;
GO



-- CONSULTA 2: Ranking mensual de clases por demanda.
-- Mide la demanda por reservas confirmadas en el mes de la sesión.
-- El promedio incluye las sesiones registradas con cero reservas.

WITH ReservasPorSesion AS (
    SELECT
        s.IdSesion,
        s.IdClase,
        DATEFROMPARTS(YEAR(s.Fecha), MONTH(s.Fecha), 1) AS Mes,
        COUNT(r.IdReserva) AS ReservasConfirmadas
    FROM dbo.SesionClase AS s
    LEFT JOIN dbo.Reserva AS r
        ON r.IdSesion = s.IdSesion
       AND r.Estado = 'Confirmada'
    GROUP BY
        s.IdSesion,
        s.IdClase,
        DATEFROMPARTS(YEAR(s.Fecha), MONTH(s.Fecha), 1)
),
DemandaMensual AS (
    SELECT
        Mes,
        IdClase,
        COUNT(*) AS SesionesRegistradas,
        SUM(ReservasConfirmadas) AS TotalReservas,
        AVG(CAST(ReservasConfirmadas AS decimal(12, 2))) AS PromedioPorSesion
    FROM ReservasPorSesion
    GROUP BY Mes, IdClase
)
SELECT
    d.Mes,
    c.Nombre AS Clase,
    d.SesionesRegistradas,
    d.TotalReservas,
    CAST(d.PromedioPorSesion AS decimal(12, 2)) AS PromedioPorSesion,
    DENSE_RANK() OVER (
        PARTITION BY d.Mes
        ORDER BY d.TotalReservas DESC
    ) AS PosicionPorDemanda
FROM DemandaMensual AS d
JOIN dbo.Clase AS c
    ON c.IdClase = d.IdClase
ORDER BY d.Mes, PosicionPorDemanda, d.IdClase;
GO



-- CONSULTA 3: Ingresos mensuales por membresía.
-- Calcula el monto cobrado, su porcentaje del total mensual
-- y la posición de cada membresía dentro del mes.

WITH IngresoMensual AS (
    SELECT
        DATEFROMPARTS(YEAR(p.Fecha), MONTH(p.Fecha), 1) AS Mes,
        p.IdMembresia,
        SUM(p.Monto) AS IngresoMembresia
    FROM dbo.Pago AS p
    WHERE p.Estado = 'Pagado'
    GROUP BY
        DATEFROMPARTS(YEAR(p.Fecha), MONTH(p.Fecha), 1),
        p.IdMembresia
)
SELECT
    i.Mes,
    m.Nombre AS Membresia,
    i.IngresoMembresia,
    CAST(
        100.0 * i.IngresoMembresia
        / NULLIF(SUM(i.IngresoMembresia) OVER (PARTITION BY i.Mes), 0)
        AS decimal(10, 2)
    ) AS PorcentajeDelIngresoMensual,
    DENSE_RANK() OVER (
        PARTITION BY i.Mes
        ORDER BY i.IngresoMembresia DESC
    ) AS PosicionPorIngreso
FROM IngresoMensual AS i
JOIN dbo.Membresia AS m
    ON m.IdMembresia = i.IdMembresia
ORDER BY i.Mes, PosicionPorIngreso, i.IdMembresia;
GO


-- CONSULTA 4: Socios registrados por tipo de membresía.
-- Incluye los planes que todavía tienen cero socios.

SELECT
    m.IdMembresia,
    m.Nombre AS Membresia,
    m.Precio,
    COUNT(s.IdSocio) AS SociosRegistrados
FROM dbo.Membresia AS m
LEFT JOIN dbo.Socio AS s
    ON s.IdMembresia = m.IdMembresia
GROUP BY m.IdMembresia, m.Nombre, m.Precio
ORDER BY SociosRegistrados DESC, m.IdMembresia;
GO


-- CONSULTA 5: Socios que nunca han realizado una reserva.
-- Una reserva cancelada sí cuenta como reserva realizada.

SELECT
    s.IdSocio,
    s.Nombres,
    s.Apellidos,
    s.FechaRegistro,
    m.Nombre AS Membresia
FROM dbo.Socio AS s
JOIN dbo.Membresia AS m
    ON m.IdMembresia = s.IdMembresia
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Reserva AS r
    WHERE r.IdSocio = s.IdSocio
)
ORDER BY s.FechaRegistro, s.IdSocio;
GO


-- CONSULTA 6: Entrenadores por especialidad.
-- También identifica especialidades sin entrenador asignado.

SELECT
    esp.Nombre AS Especialidad,
    e.IdEntrenador,
    CASE
        WHEN e.IdEntrenador IS NULL THEN 'Sin entrenador asignado'
        ELSE CONCAT(e.Nombres, ' ', e.Apellidos)
    END AS Entrenador
FROM dbo.Especialidad AS esp
LEFT JOIN dbo.EntrenadorEspecialidad AS ee
    ON ee.IdEspecialidad = esp.IdEspecialidad
LEFT JOIN dbo.Entrenador AS e
    ON e.IdEntrenador = ee.IdEntrenador
ORDER BY esp.Nombre, e.Apellidos, e.Nombres;
GO


-- CONSULTA 7: Agenda de clases de los próximos siete días, incluyendo hoy.
-- Muestra quién imparte cada sesión y su estado registrado.

SELECT
    s.IdSesion,
    c.Nombre AS Clase,
    s.Fecha,
    s.HoraInicio,
    s.HoraFin,
    CONCAT(e.Nombres, ' ', e.Apellidos) AS Entrenador,
    s.Estado AS EstadoSesion
FROM dbo.SesionClase AS s
JOIN dbo.Clase AS c
    ON c.IdClase = s.IdClase
JOIN dbo.Entrenador AS e
    ON e.IdEntrenador = s.IdEntrenador
WHERE s.Fecha >= CAST(GETDATE() AS date)
  AND s.Fecha < DATEADD(day, 7, CAST(GETDATE() AS date))
ORDER BY s.Fecha, s.HoraInicio, s.IdSesion;
GO


-- CONSULTA 8: Cantidad de socios nuevos por mes.
-- Cada socio se cuenta en el mes de su fecha de registro.

SELECT
    DATEFROMPARTS(YEAR(s.FechaRegistro), MONTH(s.FechaRegistro), 1) AS Mes,
    COUNT(*) AS SociosNuevos
FROM dbo.Socio AS s
GROUP BY DATEFROMPARTS(YEAR(s.FechaRegistro), MONTH(s.FechaRegistro), 1)
ORDER BY Mes;
GO

-- CONSULTA 9: Recaudación por método de pago.
-- Cuenta los pagos cobrados y calcula el total y el promedio.

SELECT
    p.Metodo,
    COUNT(*) AS CantidadPagos,
    SUM(p.Monto) AS TotalCobrado,
    CAST(AVG(p.Monto) AS decimal(12, 2)) AS PromedioPorPago
FROM dbo.Pago AS p
WHERE p.Estado = 'Pagado'
GROUP BY p.Metodo
ORDER BY TotalCobrado DESC, p.Metodo;
GO