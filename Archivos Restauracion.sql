USE Gimnasio;
GO
SELECT N'Socios.Membresia' AS Tabla, COUNT_BIG(*) AS Filas FROM Socios.Membresia
UNION ALL SELECT N'Socios.Socio', COUNT_BIG(*) FROM Socios.Socio
UNION ALL SELECT N'Finanzas.Pago', COUNT_BIG(*) FROM Finanzas.Pago
UNION ALL SELECT N'Personal.Especialidad', COUNT_BIG(*) FROM Personal.Especialidad
UNION ALL SELECT N'Personal.Entrenador', COUNT_BIG(*) FROM Personal.Entrenador
UNION ALL SELECT N'Personal.EntrenadorEspecialidad', COUNT_BIG(*) FROM Personal.EntrenadorEspecialidad
UNION ALL SELECT N'Operacion.Clase', COUNT_BIG(*) FROM Operacion.Clase
UNION ALL SELECT N'Operacion.SesionClase', COUNT_BIG(*) FROM Operacion.SesionClase
UNION ALL SELECT N'Operacion.Reserva', COUNT_BIG(*) FROM Operacion.Reserva;

SELECT TOP (5) IdMembresia, Nombre, Precio, Duracion
FROM Socios.Membresia ORDER BY IdMembresia;
SELECT TOP (5) IdPago, Monto, Fecha, Estado, IdMembresia
FROM Finanzas.Pago ORDER BY IdPago;
GO