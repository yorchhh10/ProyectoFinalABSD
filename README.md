# 🏋️ PROYECTO FINAL ADMINISTRACIÓN BASE DE DATOS - GIMNASIO

Proyecto de Administración de Bases de Datos desarrollado en SQL Server para el gimnasio FitZone. La base `Gimnasio` centraliza socios, planes de membresía, pagos, entrenadores, clases y reservas. Recepción puede consultar cupos y gestionar reservas, los entrenadores pueden revisar sus sesiones y el equipo de finanzas puede consultar los pagos. El proyecto también cubre permisos por función, auditoría, recuperación de datos y análisis en Power BI.

## 📝 Archivos del proyecto

| Archivo | Contenido |
| --- | --- |
| [`Gimnasio.sql`](Gimnasio.sql) | Crea la base de datos y sus nueve tablas con claves primarias, foráneas y restricciones. |
| [`SeguridadYAdmin.sql`](SeguridadYAdmin.sql) | Organiza las tablas en los esquemas `Socios`, `Operacion`, `Finanzas` y `Personal`. Configura usuarios, roles, permisos y auditoría, e incluye pruebas de acceso. |
| [`Registros.sql`](Registros.sql) | Carga los datos ficticios del gimnasio y verifica los conteos de las tablas. |
| [`Consultas.sql`](Consultas.sql) | Contiene nueve consultas y los índices de apoyo.|
| [`RespaldoGimnasio.sql`](RespaldoGimnasio.sql) | Define el plan de respaldos, la prueba de restauración, los jobs de SQL Server Agent y las consultas de su historial. |
| [`dashboardGimnasio.pbix`](dashboardGimnasio.pbix) | Informe de Power BI con indicadores de socios, reservas e ingresos, filtros y una página de seguimiento operativo. |
| [Documentación técnica (PDF)](DOCUMENTACI%C3%93N/DIAGRAMAS/Documentaci%C3%B3n%20t%C3%A9cnica%20proyecto%20ABD.pdf) | Informe con el modelo de datos, las pruebas de seguridad y auditoría, los planes de ejecución, el dimensionamiento y el dashboard. |
| [`ProyectoFinalABSD.slnx`](ProyectoFinalABSD.slnx) | Archivo de solución del proyecto. |


## 📐 Diagramas

### Diagrama entidad-relación (ER)

![Diagrama entidad-relación de la base de datos Gimnasio](DOCUMENTACI%C3%93N/DIAGRAMAS/ER%20GIMNASIO.png)

### Modelo relacional

![Modelo relacional de la base de datos Gimnasio](DOCUMENTACI%C3%93N/DIAGRAMAS/MODELO%20RELACIONAL%20GIMNASIO.png)

## 👥 Integrantes del proyecto

- Barrera Gómez, Heraldo Riquelmy
- Crisostomo, Juan Manuel
- Gonzalez Garcia, Diego Alejandro
- Claros Lopez, Erick José
- Escobar Menjivar, Jorge Alberto
