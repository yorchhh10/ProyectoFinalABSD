use Gimnasio;
go

set xact_abort on;
begin try
    begin transaction;

    if exists (select 1 from Socios.Membresia)
        throw 50001, 'La tabla Socios.Membresia ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Personal.Especialidad)
        throw 50001, 'La tabla Personal.Especialidad ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Personal.Entrenador)
        throw 50001, 'La tabla Personal.Entrenador ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Operacion.Clase)
        throw 50001, 'La tabla Operacion.Clase ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Socios.Socio)
        throw 50001, 'La tabla Socios.Socio ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Personal.EntrenadorEspecialidad)
        throw 50001, 'La tabla Personal.EntrenadorEspecialidad ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Finanzas.Pago)
        throw 50001, 'La tabla Finanzas.Pago ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Operacion.SesionClase)
        throw 50001, 'La tabla Operacion.SesionClase ya tiene datos. Se cancela la carga para evitar duplicados.', 1;
    if exists (select 1 from Operacion.Reserva)
        throw 50001, 'La tabla Operacion.Reserva ya tiene datos. Se cancela la carga para evitar duplicados.', 1;

    -- insertar primero las tablas principales y luego las dependientes

    -- Socios.Membresia: 5 registros
    insert into Socios.Membresia (Nombre, Descripcion, Precio, Duracion) values ('Basica', 'Acceso al gimnasio durante 30 dias', 20.0, 30);
    insert into Socios.Membresia (Nombre, Descripcion, Precio, Duracion) values ('Estandar', 'Gimnasio y clases grupales por 30 dias', 30.0, 30);
    insert into Socios.Membresia (Nombre, Descripcion, Precio, Duracion) values ('Premium', 'Acceso completo durante 30 dias', 45.0, 30);
    insert into Socios.Membresia (Nombre, Descripcion, Precio, Duracion) values ('Trimestral', 'Acceso al gimnasio durante 90 dias', 80.0, 90);
    insert into Socios.Membresia (Nombre, Descripcion, Precio, Duracion) values ('Anual', 'Acceso al gimnasio durante 365 dias', 280.0, 365);

    -- Personal.Especialidad: 8 registros
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Musculacion', 'Entrenamiento de fuerza y pesas');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Cardio', 'Resistencia cardiovascular');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Yoga', 'Flexibilidad y respiracion');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Pilates', 'Control postural y fuerza central');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Funcional', 'Movimientos funcionales');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Spinning', 'Ciclismo estacionario');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Boxeo', 'Tecnica y acondicionamiento');
    insert into Personal.Especialidad (Nombre, Descripcion) values ('Zumba', 'Baile y actividad aerobica');

    -- Personal.Entrenador: 12 registros
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Carlos', 'Hernandez', '10000000-0', '72000000', 'entrenador01@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Jose', 'Martinez', '10000001-1', '72000001', 'entrenador02@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Luis', 'Lopez', '10000002-2', '72000002', 'entrenador03@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Diego', 'Garcia', '10000003-3', '72000003', 'entrenador04@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Andres', 'Rodriguez', '10000004-4', '72000004', 'entrenador05@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Daniel', 'Perez', '10000005-5', '72000005', 'entrenador06@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Fernando', 'Gonzalez', '10000006-6', '72000006', 'entrenador07@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Miguel', 'Ramirez', '10000007-7', '72000007', 'entrenador08@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Jorge', 'Flores', '10000008-8', '72000008', 'entrenador09@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Ricardo', 'Rivera', '10000009-9', '72000009', 'entrenador10@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Oscar', 'Castro', '10000010-0', '72000010', 'entrenador11@gimnasio.com');
    insert into Personal.Entrenador (Nombres, Apellidos, Dui, Telefono, Correo) values ('Raul', 'Morales', '10000011-1', '72000011', 'entrenador12@gimnasio.com');

    -- Operacion.Clase: 10 registros
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Yoga inicial', 'Posturas basicas y respiracion', 60);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Spinning', 'Sesion de ciclismo indoor', 45);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Zumba', 'Baile aerobico grupal', 60);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Entrenamiento funcional', 'Circuitos de cuerpo completo', 50);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Pilates', 'Estabilidad y control corporal', 55);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Boxeo fitness', 'Boxeo sin contacto', 50);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Cardio intenso', 'Trabajo cardiovascular por intervalos', 40);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Fuerza total', 'Entrenamiento de resistencia', 60);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Estiramiento', 'Movilidad y flexibilidad', 30);
    insert into Operacion.Clase (Nombre, Descripcion, Duracion) values ('Circuito mixto', 'Fuerza y cardio combinados', 45);

    -- Socios.Socio: 100 registros
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Carlos', 'Hernandez', '20000000-0', '61000000', 'socio001@correo.com', '2025-01-05', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Maria', 'Ramirez', '20000001-1', '61000001', 'socio002@correo.com', '2025-01-09', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Jose', 'Vasquez', '20000002-2', '61000002', 'socio003@correo.com', '2025-01-13', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Ana', 'Martinez', '20000003-3', '61000003', 'socio004@correo.com', '2025-01-17', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Luis', 'Flores', '20000004-4', '61000004', 'socio005@correo.com', '2025-01-21', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Sofia', 'Romero', '20000005-5', '61000005', 'socio006@correo.com', '2025-01-25', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Diego', 'Lopez', '20000006-6', '61000006', 'socio007@correo.com', '2025-01-29', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Valeria', 'Rivera', '20000007-7', '61000007', 'socio008@correo.com', '2025-02-02', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Andres', 'Torres', '20000008-8', '61000008', 'socio009@correo.com', '2025-02-06', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Camila', 'Garcia', '20000009-9', '61000009', 'socio010@correo.com', '2025-02-10', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Daniel', 'Castro', '20000010-0', '61000010', 'socio011@correo.com', '2025-02-14', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Lucia', 'Aguilar', '20000011-1', '61000011', 'socio012@correo.com', '2025-02-18', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Fernando', 'Rodriguez', '20000012-2', '61000012', 'socio013@correo.com', '2025-02-22', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Gabriela', 'Morales', '20000013-3', '61000013', 'socio014@correo.com', '2025-02-26', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Miguel', 'Mendoza', '20000014-4', '61000014', 'socio015@correo.com', '2025-03-02', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Paola', 'Perez', '20000015-5', '61000015', 'socio016@correo.com', '2025-03-06', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Jorge', 'Cruz', '20000016-6', '61000016', 'socio017@correo.com', '2025-03-10', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Elena', 'Reyes', '20000017-7', '61000017', 'socio018@correo.com', '2025-03-14', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Ricardo', 'Gonzalez', '20000018-8', '61000018', 'socio019@correo.com', '2025-03-18', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Natalia', 'Diaz', '20000019-9', '61000019', 'socio020@correo.com', '2025-03-22', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Oscar', 'Hernandez', '20000020-0', '61000020', 'socio021@correo.com', '2025-03-26', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Daniela', 'Ramirez', '20000021-1', '61000021', 'socio022@correo.com', '2025-03-30', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Raul', 'Vasquez', '20000022-2', '61000022', 'socio023@correo.com', '2025-04-03', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Isabel', 'Martinez', '20000023-3', '61000023', 'socio024@correo.com', '2025-04-07', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Hector', 'Flores', '20000024-4', '61000024', 'socio025@correo.com', '2025-04-11', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Adriana', 'Romero', '20000025-5', '61000025', 'socio026@correo.com', '2025-04-15', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Eduardo', 'Lopez', '20000026-6', '61000026', 'socio027@correo.com', '2025-04-19', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Claudia', 'Rivera', '20000027-7', '61000027', 'socio028@correo.com', '2025-04-23', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('David', 'Torres', '20000028-8', '61000028', 'socio029@correo.com', '2025-04-27', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Karla', 'Garcia', '20000029-9', '61000029', 'socio030@correo.com', '2025-05-01', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Roberto', 'Castro', '20000030-0', '61000030', 'socio031@correo.com', '2025-05-05', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Alejandra', 'Aguilar', '20000031-1', '61000031', 'socio032@correo.com', '2025-05-09', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Francisco', 'Rodriguez', '20000032-2', '61000032', 'socio033@correo.com', '2025-05-13', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Marta', 'Morales', '20000033-3', '61000033', 'socio034@correo.com', '2025-05-17', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Emilio', 'Mendoza', '20000034-4', '61000034', 'socio035@correo.com', '2025-05-21', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Andrea', 'Perez', '20000035-5', '61000035', 'socio036@correo.com', '2025-05-25', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Manuel', 'Cruz', '20000036-6', '61000036', 'socio037@correo.com', '2025-05-29', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Patricia', 'Reyes', '20000037-7', '61000037', 'socio038@correo.com', '2025-06-02', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Samuel', 'Gonzalez', '20000038-8', '61000038', 'socio039@correo.com', '2025-06-06', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Rosa', 'Diaz', '20000039-9', '61000039', 'socio040@correo.com', '2025-06-10', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Carlos', 'Hernandez', '20000040-0', '61000040', 'socio041@correo.com', '2025-06-14', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Maria', 'Ramirez', '20000041-1', '61000041', 'socio042@correo.com', '2025-06-18', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Jose', 'Vasquez', '20000042-2', '61000042', 'socio043@correo.com', '2025-06-22', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Ana', 'Martinez', '20000043-3', '61000043', 'socio044@correo.com', '2025-06-26', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Luis', 'Flores', '20000044-4', '61000044', 'socio045@correo.com', '2025-06-30', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Sofia', 'Romero', '20000045-5', '61000045', 'socio046@correo.com', '2025-07-04', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Diego', 'Lopez', '20000046-6', '61000046', 'socio047@correo.com', '2025-07-08', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Valeria', 'Rivera', '20000047-7', '61000047', 'socio048@correo.com', '2025-07-12', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Andres', 'Torres', '20000048-8', '61000048', 'socio049@correo.com', '2025-07-16', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Camila', 'Garcia', '20000049-9', '61000049', 'socio050@correo.com', '2025-07-20', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Daniel', 'Castro', '20000050-0', '61000050', 'socio051@correo.com', '2025-07-24', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Lucia', 'Aguilar', '20000051-1', '61000051', 'socio052@correo.com', '2025-07-28', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Fernando', 'Rodriguez', '20000052-2', '61000052', 'socio053@correo.com', '2025-08-01', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Gabriela', 'Morales', '20000053-3', '61000053', 'socio054@correo.com', '2025-08-05', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Miguel', 'Mendoza', '20000054-4', '61000054', 'socio055@correo.com', '2025-08-09', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Paola', 'Perez', '20000055-5', '61000055', 'socio056@correo.com', '2025-08-13', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Jorge', 'Cruz', '20000056-6', '61000056', 'socio057@correo.com', '2025-08-17', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Elena', 'Reyes', '20000057-7', '61000057', 'socio058@correo.com', '2025-08-21', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Ricardo', 'Gonzalez', '20000058-8', '61000058', 'socio059@correo.com', '2025-08-25', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Natalia', 'Diaz', '20000059-9', '61000059', 'socio060@correo.com', '2025-08-29', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Oscar', 'Hernandez', '20000060-0', '61000060', 'socio061@correo.com', '2025-09-02', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Daniela', 'Ramirez', '20000061-1', '61000061', 'socio062@correo.com', '2025-09-06', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Raul', 'Vasquez', '20000062-2', '61000062', 'socio063@correo.com', '2025-09-10', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Isabel', 'Martinez', '20000063-3', '61000063', 'socio064@correo.com', '2025-09-14', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Hector', 'Flores', '20000064-4', '61000064', 'socio065@correo.com', '2025-09-18', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Adriana', 'Romero', '20000065-5', '61000065', 'socio066@correo.com', '2025-09-22', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Eduardo', 'Lopez', '20000066-6', '61000066', 'socio067@correo.com', '2025-09-26', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Claudia', 'Rivera', '20000067-7', '61000067', 'socio068@correo.com', '2025-09-30', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('David', 'Torres', '20000068-8', '61000068', 'socio069@correo.com', '2025-10-04', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Karla', 'Garcia', '20000069-9', '61000069', 'socio070@correo.com', '2025-10-08', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Roberto', 'Castro', '20000070-0', '61000070', 'socio071@correo.com', '2025-10-12', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Alejandra', 'Aguilar', '20000071-1', '61000071', 'socio072@correo.com', '2025-10-16', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Francisco', 'Rodriguez', '20000072-2', '61000072', 'socio073@correo.com', '2025-10-20', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Marta', 'Morales', '20000073-3', '61000073', 'socio074@correo.com', '2025-10-24', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Emilio', 'Mendoza', '20000074-4', '61000074', 'socio075@correo.com', '2025-10-28', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Andrea', 'Perez', '20000075-5', '61000075', 'socio076@correo.com', '2025-11-01', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Manuel', 'Cruz', '20000076-6', '61000076', 'socio077@correo.com', '2025-11-05', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Patricia', 'Reyes', '20000077-7', '61000077', 'socio078@correo.com', '2025-11-09', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Samuel', 'Gonzalez', '20000078-8', '61000078', 'socio079@correo.com', '2025-11-13', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Rosa', 'Diaz', '20000079-9', '61000079', 'socio080@correo.com', '2025-11-17', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Carlos', 'Hernandez', '20000080-0', '61000080', 'socio081@correo.com', '2025-11-21', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Maria', 'Ramirez', '20000081-1', '61000081', 'socio082@correo.com', '2025-11-25', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Jose', 'Vasquez', '20000082-2', '61000082', 'socio083@correo.com', '2025-11-29', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Ana', 'Martinez', '20000083-3', '61000083', 'socio084@correo.com', '2025-12-03', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Luis', 'Flores', '20000084-4', '61000084', 'socio085@correo.com', '2025-12-07', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Sofia', 'Romero', '20000085-5', '61000085', 'socio086@correo.com', '2025-12-11', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Diego', 'Lopez', '20000086-6', '61000086', 'socio087@correo.com', '2025-12-15', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Valeria', 'Rivera', '20000087-7', '61000087', 'socio088@correo.com', '2025-12-19', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Andres', 'Torres', '20000088-8', '61000088', 'socio089@correo.com', '2025-12-23', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Camila', 'Garcia', '20000089-9', '61000089', 'socio090@correo.com', '2025-12-27', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Daniel', 'Castro', '20000090-0', '61000090', 'socio091@correo.com', '2025-12-31', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Lucia', 'Aguilar', '20000091-1', '61000091', 'socio092@correo.com', '2026-01-04', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Fernando', 'Rodriguez', '20000092-2', '61000092', 'socio093@correo.com', '2026-01-08', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Gabriela', 'Morales', '20000093-3', '61000093', 'socio094@correo.com', '2026-01-12', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Miguel', 'Mendoza', '20000094-4', '61000094', 'socio095@correo.com', '2026-01-16', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Paola', 'Perez', '20000095-5', '61000095', 'socio096@correo.com', '2026-01-20', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Jorge', 'Cruz', '20000096-6', '61000096', 'socio097@correo.com', '2026-01-24', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Elena', 'Reyes', '20000097-7', '61000097', 'socio098@correo.com', '2026-01-28', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Ricardo', 'Gonzalez', '20000098-8', '61000098', 'socio099@correo.com', '2026-02-01', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Socios.Socio (Nombres, Apellidos, Dui, Telefono, Correo, FechaRegistro, IdMembresia) values ('Natalia', 'Diaz', '20000099-9', '61000099', 'socio100@correo.com', '2026-02-05', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));

    -- Personal.EntrenadorEspecialidad: 15 registros
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000000-0'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Musculacion'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000001-1'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Cardio'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000002-2'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Yoga'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000003-3'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Pilates'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000004-4'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Funcional'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000005-5'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Spinning'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000006-6'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Boxeo'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000007-7'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Zumba'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000008-8'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Musculacion'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000009-9'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Cardio'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000010-0'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Yoga'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000011-1'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Pilates'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000001-1'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Funcional'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000004-4'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Cardio'));
    insert into Personal.EntrenadorEspecialidad (IdEntrenador, IdEspecialidad) values ((select IdEntrenador from Personal.Entrenador where Dui = '10000007-7'), (select IdEspecialidad from Personal.Especialidad where Nombre = 'Spinning'));

    -- Finanzas.Pago: 100 registros
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-02-01', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-02-04', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-02-07', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-02-10', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-02-13', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-02-16', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-02-19', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-02-22', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-02-25', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-02-28', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-03-03', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-03-06', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-03-09', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-03-12', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-03-15', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-03-18', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-03-21', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-03-24', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-03-27', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-03-30', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-04-02', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-04-05', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-04-08', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-04-11', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-04-14', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-04-17', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-04-20', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-04-23', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-04-26', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-04-29', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-05-02', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-05-05', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-05-08', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-05-11', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-05-14', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-05-17', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-05-20', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-05-23', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-05-26', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-05-29', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-06-01', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-06-04', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-06-07', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-06-10', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-06-13', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-06-16', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-06-19', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-06-22', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-06-25', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-06-28', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-07-01', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-07-04', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-07-07', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-07-10', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-07-13', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-07-16', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-07-19', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-07-22', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-07-25', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-07-28', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-07-31', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-08-03', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-08-06', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-08-09', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-08-12', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-08-15', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-08-18', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-08-21', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-08-24', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-08-27', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-08-30', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-09-02', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-09-05', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-09-08', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-09-11', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-09-14', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-09-17', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-09-20', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-09-23', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-09-26', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-09-29', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-10-02', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-10-05', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-10-08', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-10-11', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-10-14', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-10-17', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-10-20', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-10-23', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-10-26', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-10-29', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-11-01', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-11-04', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-11-07', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-11-10', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (20.00, '2025-11-13', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Basica'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (30.00, '2025-11-16', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Estandar'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (45.00, '2025-11-19', 'Tarjeta', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Premium'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (80.00, '2025-11-22', 'Transferencia', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Trimestral'));
    insert into Finanzas.Pago (Monto, Fecha, Metodo, Estado, IdMembresia) values (280.00, '2025-11-25', 'Efectivo', 'Pagado', (select IdMembresia from Socios.Membresia where Nombre = 'Anual'));

    -- Operacion.SesionClase: 20 registros
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-09', '07:00:00', '08:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000000-0'), (select IdClase from Operacion.Clase where Nombre = 'Yoga inicial'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-09', '17:00:00', '18:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000001-1'), (select IdClase from Operacion.Clase where Nombre = 'Spinning'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-10', '07:00:00', '08:00:00', 30, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000002-2'), (select IdClase from Operacion.Clase where Nombre = 'Zumba'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-10', '17:00:00', '18:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000003-3'), (select IdClase from Operacion.Clase where Nombre = 'Entrenamiento funcional'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-11', '07:00:00', '08:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000004-4'), (select IdClase from Operacion.Clase where Nombre = 'Pilates'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-11', '17:00:00', '18:00:00', 30, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000005-5'), (select IdClase from Operacion.Clase where Nombre = 'Boxeo fitness'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-12', '07:00:00', '08:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000006-6'), (select IdClase from Operacion.Clase where Nombre = 'Cardio intenso'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-12', '17:00:00', '18:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000007-7'), (select IdClase from Operacion.Clase where Nombre = 'Fuerza total'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-13', '07:00:00', '08:00:00', 30, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000008-8'), (select IdClase from Operacion.Clase where Nombre = 'Estiramiento'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-13', '17:00:00', '18:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000009-9'), (select IdClase from Operacion.Clase where Nombre = 'Circuito mixto'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-14', '07:00:00', '08:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000010-0'), (select IdClase from Operacion.Clase where Nombre = 'Yoga inicial'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-14', '17:00:00', '18:00:00', 30, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000011-1'), (select IdClase from Operacion.Clase where Nombre = 'Spinning'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-15', '07:00:00', '08:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000000-0'), (select IdClase from Operacion.Clase where Nombre = 'Zumba'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-15', '17:00:00', '18:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000001-1'), (select IdClase from Operacion.Clase where Nombre = 'Entrenamiento funcional'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-16', '07:00:00', '08:00:00', 30, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000002-2'), (select IdClase from Operacion.Clase where Nombre = 'Pilates'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-16', '17:00:00', '18:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000003-3'), (select IdClase from Operacion.Clase where Nombre = 'Boxeo fitness'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-17', '07:00:00', '08:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000004-4'), (select IdClase from Operacion.Clase where Nombre = 'Cardio intenso'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-17', '17:00:00', '18:00:00', 30, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000005-5'), (select IdClase from Operacion.Clase where Nombre = 'Fuerza total'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-18', '07:00:00', '08:00:00', 20, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000006-6'), (select IdClase from Operacion.Clase where Nombre = 'Estiramiento'));
    insert into Operacion.SesionClase (Fecha, HoraInicio, HoraFin, CupoMaximo, Estado, IdEntrenador, IdClase) values ('2026-11-18', '17:00:00', '18:00:00', 25, 'Programada', (select IdEntrenador from Personal.Entrenador where Dui = '10000007-7'), (select IdClase from Operacion.Clase where Nombre = 'Circuito mixto'));

    -- Operacion.Reserva: 30 registros
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-01', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000000-0'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-09' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-02', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000001-1'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-09' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-03', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000002-2'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-10' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-04', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000003-3'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-10' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-05', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000004-4'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-11' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-06', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000005-5'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-11' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-01', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000006-6'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-12' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-02', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000007-7'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-12' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-03', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000008-8'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-13' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-04', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000009-9'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-13' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-05', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000010-0'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-14' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-06', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000011-1'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-14' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-01', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000012-2'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-15' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-02', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000013-3'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-15' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-03', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000014-4'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-16' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-04', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000015-5'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-16' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-05', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000016-6'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-17' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-06', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000017-7'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-17' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-01', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000018-8'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-18' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-02', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000019-9'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-18' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-03', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000020-0'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-09' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-04', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000021-1'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-09' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-05', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000022-2'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-10' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-06', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000023-3'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-10' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-01', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000024-4'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-11' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-02', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000025-5'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-11' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-03', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000026-6'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-12' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-04', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000027-7'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-12' and HoraInicio = '17:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-05', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000028-8'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-13' and HoraInicio = '07:00:00'));
    insert into Operacion.Reserva (Fecha, Estado, IdSocio, IdSesion) values ('2026-11-06', 'Confirmada', (select IdSocio from Socios.Socio where Dui = '20000029-9'), (select IdSesion from Operacion.SesionClase where Fecha = '2026-11-13' and HoraInicio = '17:00:00'));

    commit transaction;
end try
begin catch
    if @@trancount > 0
        rollback transaction;
    throw;
end catch;
go

-- comprobar la cantidad insertada en cada tabla
select 'Membresia' as Tabla, count(*) as Cantidad from Socios.Membresia
union all select 'Socio', count(*) from Socios.Socio
union all select 'Pago', count(*) from Finanzas.Pago
union all select 'Especialidad', count(*) from Personal.Especialidad
union all select 'Entrenador', count(*) from Personal.Entrenador
union all select 'EntrenadorEspecialidad', count(*) from Personal.EntrenadorEspecialidad
union all select 'Clase', count(*) from Operacion.Clase
union all select 'SesionClase', count(*) from Operacion.SesionClase
union all select 'Reserva', count(*) from Operacion.Reserva;
