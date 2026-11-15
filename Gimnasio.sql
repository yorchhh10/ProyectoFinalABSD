
create database Gimnasio;
go

use Gimnasio;
go

-- tabla Membresia
create table Membresia (
    IdMembresia int identity(1,1) primary key,
    Nombre varchar(100) not null,
    Descripcion varchar(255),
    Precio decimal(10,2) not null,
    Duracion int not null
);

-- tabla Socio
create table Socio (
    IdSocio int identity(1,1) primary key,
    Nombres varchar(100) not null,
    Apellidos varchar(100) not null,
    Dui varchar(10) not null unique,
    Telefono varchar(15),
    Correo varchar(100),
    FechaRegistro date not null,
    IdMembresia int not null,
    foreign key (IdMembresia) references Membresia(IdMembresia)
);

-- tabla Pago
create table Pago (
    IdPago int identity(1,1) primary key,
    Monto decimal(10,2) not null,
    Fecha date not null,
    Metodo varchar(50) not null,
    Estado varchar(30) not null,
    IdMembresia int not null,
    foreign key (IdMembresia) references Membresia(IdMembresia)
);

-- tabla Especialidad
create table Especialidad (
    IdEspecialidad int identity(1,1) primary key,
    Nombre varchar(100) not null,
    Descripcion varchar(255)
);

-- tabla Entrenador
create table Entrenador (
    IdEntrenador int identity(1,1) primary key,
    Nombres varchar(100) not null,
    Apellidos varchar(100) not null,
    Dui varchar(10) not null unique,
    Telefono varchar(15),
    Correo varchar(100)
);

-- tabla EntrenadorEspecialidad
create table EntrenadorEspecialidad (
    IdEntrenador int not null,
    IdEspecialidad int not null,
    primary key (IdEntrenador, IdEspecialidad),
    foreign key (IdEntrenador) references Entrenador(IdEntrenador),
    foreign key (IdEspecialidad) references Especialidad(IdEspecialidad)
);

-- tabla Clase
create table Clase (
    IdClase int identity(1,1) primary key,
    Nombre varchar(100) not null,
    Descripcion varchar(255),
    Duracion int not null
);

-- tabla SesionClase
create table SesionClase (
    IdSesion int identity(1,1) primary key,
    Fecha date not null,
    HoraInicio time not null,
    HoraFin time not null,
    CupoMaximo int not null,
    Estado varchar(30) not null,
    IdEntrenador int not null,
    IdClase int not null,
    foreign key (IdEntrenador) references Entrenador(IdEntrenador),
    foreign key (IdClase) references Clase(IdClase)
);

-- tabla Reserva
create table Reserva (
    IdReserva int identity(1,1) primary key,
    Fecha date not null,
    Estado varchar(30) not null,
    IdSocio int not null,
    IdSesion int not null,
    foreign key (IdSocio) references Socio(IdSocio),
    foreign key (IdSesion) references SesionClase(IdSesion)
);
