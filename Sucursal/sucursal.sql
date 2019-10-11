CREATE DATABASE IF NOT EXISTS Sucursal;
USE Sucursal;

CREATE TABLE IF NOT EXISTS Categoria (
	IdCategoria INT NOT NULL AUTO_INCREMENT,
    Categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (IdCategoria)
);

CREATE TABLE IF NOT EXISTS Marca (
	IdMarca INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (IdMarca)
);

CREATE TABLE IF NOT EXISTS Genero (
    IdGenero INT NOT NULL AUTO_INCREMENT,
    Genero VARCHAR(50) NOT NULL,
    PRIMARY KEY (IdGenero)
);

CREATE TABLE IF NOT EXISTS Tipo(
	IdTipo INT NOT NULL AUTO_INCREMENT,
    Tipo VARCHAR(50) NOT NULL,
    PRIMARY KEY (IdTipo)
);

CREATE TABLE IF NOT EXISTS Producto (
    IdProducto INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    Precio INT NOT NULL,
    Estado VARCHAR(15) NOT NULL,
    FechaRegistro DATE NOT NULL,
    IdTipo INT NOT NULL,
    IdMarca INT NOT NULL,
    IdGenero INT NOT NULL,
    PRIMARY KEY (IdProducto),
    FOREIGN KEY (IdTipo)
        REFERENCES Tipo (IdTipo),
    FOREIGN KEY (IdMarca)
        REFERENCES Marca (IdMarca),
    FOREIGN KEY (IdGenero)
        REFERENCES Genero (IdGenero)
);

CREATE TABLE IF NOT EXISTS Articulo (
	IdArticulo INT NOT NULL AUTO_INCREMENT,
    Codigo VARCHAR(15) NOT NULL,
    FechaIngreso DATE NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    FechaGarantia DATE,
	TiempoGarantia INT NOT NULL,
    Precio INT NOT NULL,
    IdProducto INT NOT NULL,
    PRIMARY KEY (IdArticulo),
    FOREIGN KEY (IdProducto)
		REFERENCES Producto (IdProducto)
);

CREATE TABLE IF NOT EXISTS Promocion (
	IdPromocion INT NOT NULL AUTO_INCREMENT,
    Codigo VARCHAR(20) NOT NULL,
    FechaInicio DATETIME NOT NULL,
    FechaFinal DATETIME NOT NULL,
    Descuento INT NOT NULL,
    PRIMARY KEY (IdPromocion)
);

CREATE TABLE IF NOT EXISTS Pais (
	IdPais INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (IdPais)
);

CREATE TABLE IF NOT EXISTS Provincia (
    IdProvincia INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    IdPais INT NOT NULL,
    PRIMARY KEY (IdProvincia),
    FOREIGN KEY (IdPais)
        REFERENCES Pais (IdPais)
);

CREATE TABLE IF NOT EXISTS Canton (
    IdCanton INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    IdProvincia INT NOT NULL,
    PRIMARY KEY (IdCanton),
    FOREIGN KEY (IdProvincia)
        REFERENCES Provincia (IdProvincia)
);

CREATE TABLE IF NOT EXISTS Distrito (
	IdDistrito INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    IdCanton INT NOT NULL,
    PRIMARY KEY (IdDistrito),
    FOREIGN KEY (IdCanton)
		REFERENCES Canton (IdCanton)
);


CREATE TABLE IF NOT EXISTS Ubicacion (
	IdUbicacion INT NOT NULL AUTO_INCREMENT,
    DetalleUbicacion VARCHAR(255) NOT NULL,
    IdDistrito INT NULL,
    PRIMARY KEY (IdUbicacion),
    FOREIGN KEY (IdDistrito)
		REFERENCES Distrito (IdDistrito)
);

CREATE TABLE IF NOT EXISTS Persona (
	IdPersona INT NOT NULL AUTO_INCREMENT,
	Cedula VARCHAR(50) NOT NULL UNIQUE,
    Nombre VARCHAR(50) NOT NULL,
    Apellido1 VARCHAR(50) NOT NULL,
    Apellido2 VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefono VARCHAR(50) NOT NULL,
    IdUbicacion INT NOT NULL,
    PRIMARY KEY (IdPersona),
    FOREIGN KEY (IdUbicacion)
		REFERENCES Ubicacion(IdUbicacion)
);

CREATE TABLE IF NOT EXISTS Horario (
	IdHorario INT NOT NULL AUTO_INCREMENT,
    Lunes BIT NOT NULL,
    Martes BIT NOT NULL,
    Miercoles BIT NOT NULL,
    Jueves BIT NOT NULL,
    Viernes BIT NOT NULL,
    Sabado BIT NOT NULL,
    Domingo BIT NOT NULL,
    Entrada DATETIME NOT NULL,
    Salida DATETIME NOT NULL,
    PRIMARY KEY (IdHorario)
);

CREATE TABLE IF NOT EXISTS Cliente (
	IdCliente INT NOT NULL AUTO_INCREMENT,
    PuntosAcumulados INT NOT NULL,
    FechaRegistro DATE NOT NULL,
    IdPersona INT NOT NULL,
    PRIMARY KEY (IdCliente),
    FOREIGN KEY (IdPersona)
		REFERENCES Persona (IdPersona)
);

CREATE TABLE IF NOT EXISTS Puesto (
	IdPuesto INT NOT NULL AUTO_INCREMENT,
	Puesto VARCHAR(50) NOT NULL,
    SalarioBase INTEGER NOT NULL,
    PRIMARY KEY (IdPuesto)
);

CREATE TABLE IF NOT EXISTS Empleado (
    IdEmpleado INT NOT NULL AUTO_INCREMENT,
    Estado VARCHAR(10) NOT NULL,
    FechaIngreso DATE NOT NULL,
    Salario INT NOT NULL,
    IdPuesto INT NOT NULL,
    IdPersona INT NOT NULL,
    IdHorario INT NOT NULL,
    PRIMARY KEY (IdEmpleado),
    FOREIGN KEY (IdPuesto)
        REFERENCES Puesto (IdPuesto),
    FOREIGN KEY (IdPersona)
        REFERENCES Persona (IdPersona),
    FOREIGN KEY (IdHorario)
        REFERENCES Horario (IdHorario)
);

CREATE TABLE IF NOT EXISTS EmpleadoMes (
    IdEmpleadoMes INT NOT NULL AUTO_INCREMENT,
    Mes DATE NOT NULL,
    IdEmpleado INT NOT NULL,
    PRIMARY KEY (IdEmpleadoMes),
    FOREIGN KEY (IdEmpleado)
        REFERENCES Empleado (IdEmpleado)
);

CREATE TABLE IF NOT EXISTS Factura (
    IdFactura INT NOT NULL AUTO_INCREMENT,
    FechaCompra DATETIME NOT NULL,
    PuntosGanados INT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    Total INT NOT NULL,
    IdEmpleado INT NOT NULL,
    IdCliente INT NOT NULL,
    PRIMARY KEY (IdFactura),
    FOREIGN KEY (IdEmpleado)
        REFERENCES Empleado (IdEmpleado),
    FOREIGN KEY (IdCliente)
        REFERENCES Cliente (IdCliente)
);

CREATE TABLE IF NOT EXISTS ArticuloXFactura (
	IdArticulo INT NOT NULL,
    IdFactura INT NOT NULL,
    FOREIGN KEY (IdArticulo)
		REFERENCES Articulo (IdArticulo),
    FOREIGN KEY (IdFactura)
		REFERENCES Factura (IdFactura)
);

CREATE TABLE IF NOT EXISTS CategoriaXProducto (
	IdCategoria INT NOT NULL,
    IdProducto INT NOT NULL,
    FOREIGN KEY (IdCategoria)
		REFERENCES Categoria (IdCategoria),
    FOREIGN KEY (IdProducto)
		REFERENCES Producto (IdProducto)
);

CREATE TABLE IF NOT EXISTS PromocionXArticulo(
	IdPromocion INT NOT NULL,
    IdArticulo INT NOT NULL,
    FOREIGN KEY (IdPromocion)
		REFERENCES Promocion (IdPromocion),
	FOREIGN KEY (IdArticulo)
		REFERENCES Articulo (IdArticulo)
);
