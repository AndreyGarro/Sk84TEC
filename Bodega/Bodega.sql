-- Database: ProyectoUno

-- DROP DATABASE "ProyectoUno";

-- CREATE DATABASE IF NOT EXISTS "ProyectoUno"
--     WITH 
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'English_United States.1252'
--     LC_CTYPE = 'English_United States.1252'
--     TABLESPACE = pg_default
--    CONNECTION LIMIT = -1;

-- CREATE TABLE IF NOT EXISTS Camion
-- (
--  IdCamion SERIAL NOT NULL,
--  Estado VARCHAR(30) NOT NULL,
-- 	Capacidad INT4 NOT NULL,
-- 	Placa VARCHAR(30) NOT NULL,
-- 	PRIMARY KEY(IdCamion)
-- );

-- CREATE TABLE IF NOT EXISTS Tipo
-- (
-- 	IdTipo SERIAL NOT NULL,
-- 	Tipo VARCHAR(50) NOT NULL,
-- 	PRIMARY KEY(IdTipo)
-- );	

-- CREATE TABLE IF NOT EXISTS Categoria
-- (
-- 	IdCategoria SERIAL NOT NULL,
-- 	Categoria VARCHAR(50) NOT NULL,
-- 	PRIMARY KEY(IdCategoria)
-- );

-- CREATE TABLE IF NOT EXISTS Marca
-- (
-- 	IdMarca SERIAL NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	PRIMARY KEY(IdMarca)
-- );

-- CREATE TABLE IF NOT EXISTS Genero
-- (
-- 	IdGenero SERIAL NOT NULL,
-- 	Genero VARCHAR(30) NOT NULL,
-- 	PRIMARY KEY(IdGenero)
-- );

-- CREATE TABLE IF NOT EXISTS Producto
-- (
-- 	IdProducto SERIAL NOT NULL,
-- 	Nombre VARCHAR(100) NOT NULL,
-- 	Descripcion VARCHAR(255) NOT NULL,
-- 	Precio INT4 NOT NULL,
-- 	Estado VARCHAR(30),
-- 	FechaRegistro TIMESTAMP,
-- 	TiempoGarantia INT2,
-- 	IdTipo INT4,
-- 	IdMarca INT4,
-- 	IdGenero INT4,
-- 	FOREIGN KEY (IdTipo)
-- 		REFERENCES Tipo(IdTipo),
-- 	FOREIGN KEY (IdMarca) 
-- 		REFERENCES Marca(IdMarca),
-- 	FOREIGN KEY (IdGenero) 
-- 		REFERENCES Genero(IdGenero),
-- 	PRIMARY KEY(IdProducto)
-- );

-- CREATE TABLE IF NOT EXISTS Pais
-- (
-- 	IdPais SERIAL NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	PRIMARY KEY(IdPais)
-- );

-- CREATE TABLE IF NOT EXISTS Provincia
-- (
-- 	IdProvincia SERIAL NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	IdPais INT4 NOT NULL,
-- 	FOREIGN KEY (IdPais) 
-- 		REFERENCES Pais(IdPais),
-- 	PRIMARY KEY(IdProvincia)
-- );

-- CREATE TABLE IF NOT EXISTS Canton
-- (
-- 	IdCanton SERIAL NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	IdProvincia INT4 NOT NULL,
-- 	FOREIGN KEY (IdProvincia) 
-- 		REFERENCES Provincia(IdProvincia),
-- 	PRIMARY KEY(IdCanton)
-- );

-- CREATE TABLE IF NOT EXISTS Distrito
-- (
-- 	IdDistrito SERIAL NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	IdCanton INT4 NOT NULL,
-- 	FOREIGN KEY (IdCanton) 
-- 		REFERENCES Canton(IdCanton),
-- 	PRIMARY KEY(IdDistrito)
-- );

-- CREATE TABLE IF NOT EXISTS Ubicacion
-- (
-- 	IdUbicacion SERIAL NOT NULL,
-- 	NombrePueblo VARCHAR(50) NOT NULL,
-- 	DetalleUbicacion VARCHAR(255) NOT NULL,
-- 	IdDistrito INT4 NOT NULL,
-- 	FOREIGN KEY (IdDistrito) 
-- 		REFERENCES Distrito(IdDistrito),
-- 	PRIMARY KEY(IdUbicacion)
-- );

-- CREATE TABLE IF NOT EXISTS Persona
-- (
-- 	IdPersona SERIAL NOT NULL,
-- 	Cedula VARCHAR(50) NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	Apellido1 VARCHAR(50) NOT NULL,
-- 	Apellido2 VARCHAR(50) NOT NULL,
-- 	Email VARCHAR(255) NOT NULL,
-- 	Telefono VARCHAR(50) NOT NULL,
-- 	IdUbicacion INT4 NOT NULL,
-- 	FOREIGN KEY (IdUbicacion) 
-- 		REFERENCES Ubicacion(IdUbicacion),
-- 	PRIMARY KEY(IdPersona)
-- );

-- CREATE TABLE IF NOT EXISTS Cliente 
-- (
-- 	IdCliente SERIAL NOT NULL,
-- 	PuntosAcumulados INT2 NULL,
-- 	FechaRegistro DATE NOT NULL,
-- 	IdPersona INT4,
-- 	FOREIGN KEY (IdPersona) 
-- 		REFERENCES Persona(IdPersona),
-- 	PRIMARY KEY(IdCliente)
-- );

-- CREATE TABLE IF NOT EXISTS Puesto 
-- (
-- 	IdPuesto SERIAL NOT NULL,
-- 	Puesto VARCHAR(100) NOT NULL,
-- 	SalarioBase INT2 NOT NULL,
-- 	PRIMARY KEY(IdPuesto)
-- );

-- CREATE TABLE IF NOT EXISTS Horario
-- (
-- 	IdHorario SERIAL NOT NULL,
-- 	Lunes BOOL NULL,
-- 	Martes BOOL NULL,
-- 	Miercoles BOOL NULL,
-- 	Jueves BOOL NULL,
-- 	Viernes BOOL NULL,
-- 	Sabado BOOL NULL,
-- 	Domingo BOOL NULL,
-- 	Apertura TIME NOT NULL,
-- 	Cierre TIME NOT NULL,
-- 	PRIMARY KEY(IdHorario)
-- );

-- CREATE TABLE IF NOT EXISTS Sucursal
-- (
-- 	IdSucursal SERIAL NOT NULL,
-- 	Nombre VARCHAR(50) NOT NULL,
-- 	Descripcion VARCHAR(50) NOT NULL,
-- 	Estado VARCHAR(20) NOT NULL,
-- 	IdUbicacion INT4 NOT NULL,
-- 	IdHorario INT4 NOT NULL,
-- 	FOREIGN KEY (IdUbicacion) 
-- 		REFERENCES Ubicacion(IdUbicacion),
-- 	FOREIGN KEY (IdHorario) 
-- 		REFERENCES Horario(IdHorario),
-- 	PRIMARY KEY(IdSucursal)
-- );

-- CREATE TABLE IF NOT EXISTS Articulo 
-- (
-- 	IdArticulo SERIAL NOT NULL,
-- 	FechaIngreso DATE NOT NULL,
-- 	Codigo VARCHAR(30) NOT NULL,
-- 	FechaGarantia DATE NOT NULL,
-- 	TiempoGarantia INT2,
--  	Precio INT4 NULL,
-- 	Estado VARCHAR(50) NOT NULL,
-- 	IdSucursal INT4 NULL,
-- 	IdProducto INT4 NOT NULL,
-- 	FOREIGN KEY (IdSucursal) 
-- 		REFERENCES Sucursal(IdSucursal),
-- 	FOREIGN KEY (IdProducto) 
-- 		REFERENCES Producto(IdProducto),
-- 	PRIMARY KEY(IdArticulo)
-- );


-- CREATE TABLE IF NOT EXISTS Promocion 
-- (
-- 	IdPromocion SERIAL NOT NULL,
-- 	CodigoPromocion VARCHAR(30) NOT NULL,
-- 	FechaInicio TIMESTAMP NOT NULL,
-- 	FechaFinal TIMESTAMP NOT NULL,
-- 	Descuento INT2 NOT NULL,
-- 	PRIMARY KEY(IdPromocion)
-- );

-- CREATE TABLE IF NOT EXISTS PromocionXProducto
-- (
-- 	IdProducto INT4 NOT NULL,
-- 	IdPromocion INT4 NOT NULL,
-- 	FOREIGN KEY (IdProducto)
-- 		REFERENCES Producto(IdProducto),
-- 	FOREIGN KEY (IdPromocion)
-- 		REFERENCES Promocion(IdPromocion)
-- );


-- CREATE TABLE IF NOT EXISTS Envio 
-- (
-- 	IdEnvio SERIAL NOT NULL,
-- 	Fecha TIMESTAMP NOT NULL,
-- 	CodigoEnvio VARCHAR(30) NOT NULL,
-- 	IdSucursal INT4 NOT NULL,
-- 	FOREIGN KEY (IdSucursal) 
-- 		REFERENCES Sucursal(IdSucursal),
-- 	PRIMARY KEY(IdEnvio)
-- );


-- CREATE TABLE IF NOT EXISTS ArticuloEnvio
-- (
-- 	IdArticuloEnvio SERIAL NOT NULL,
-- 	IdEnvio INT4 NOT NULL,
-- 	IdArticulo INT4 NOT NULL,
-- 	FOREIGN KEY (IdArticulo) 
-- 		REFERENCES Articulo(IdArticulo),
-- 	FOREIGN KEY (IdEnvio) 
-- 		REFERENCES Envio(IdEnvio),
-- 	PRIMARY KEY (IdArticuloEnvio)
-- );

-- CREATE TABLE IF NOT EXISTS Empleado
-- (
-- 	IdEmpleado SERIAL NOT NULL,
-- 	Estado VARCHAR(20) NOT NULL,
-- 	FechaIngreso DATE NOT NULL,
-- 	Salario INT2 NOT NULL,
-- 	IdPuesto INT4 NOT NULL,
-- 	IdPersona INT4 NOT NULL,
-- 	IdHorario INT4 NOT NULL,
-- 	FOREIGN KEY (IdPuesto) 
-- 		REFERENCES Puesto(IdPuesto),
-- 	FOREIGN KEY (IdPersona) 
-- 		REFERENCES Persona(IdPersona),
-- 	FOREIGN KEY (IdHorario) 
-- 		REFERENCES Horario(IdHorario),
-- 	PRIMARY KEY (IdEmpleado)
-- );

-- CREATE TABLE IF NOT EXISTS EmpleadoSucursal
-- (	
-- 	IdEmpleadoSucursal SERIAL NOT NULL,
-- 	IdSucursal INT4 NOT NULL,
-- 	IdEmpleado INT4 NOT NULL,
-- 	FOREIGN KEY(IdSucursal)
-- 		REFERENCES Sucursal(IdSucursal),
-- 	FOREIGN KEY(IdEmpleado)
-- 		REFERENCES Empleado(IdEmpleado),
-- 	PRIMARY KEY (IdEmpleadoSucursal)
-- );

-- CREATE TABLE IF NOT EXISTS EmpleadoMes
-- (
-- 	IdEmpleadoMes SERIAL NOT NULL,
-- 	IdSucursal INT4 NOT NULL,
-- 	IdEmpleadoSucursal INT4 NOT NULL,
-- 	FOREIGN KEY (IdSucursal)
-- 		REFERENCES Sucursal(IdSucursal),
-- 	FOREIGN KEY (IdEmpleadoSucursal)
-- 		REFERENCES EmpleadoSucursal(IdEmpleadoSucursal),
-- 	PRIMARY KEY(IdEmpleadoMes)
-- );

-- CREATE TABLE IF NOT EXISTS AdministradorSucursal
-- (
-- 	IdEmpleadoSucursal INT4 NOT NULL,
-- 	IdSucursal INT4 NOT NULL,
-- 	FechaInicio DATE NOT NULL,
-- 	FechaFinal DATE NULL,
-- 	FOREIGN KEY (IdEmpleadoSucursal) 
-- 		REFERENCES EmpleadoSucursal(IdEmpleadoSucursal),
-- 	FOREIGN KEY (IdSucursal) 
-- 		REFERENCES Sucursal(IdSucursal)
-- );

-- CREATE TABLE IF NOT EXISTS Factura
-- (
-- 	IdFactura SERIAL NOT NULL,
-- 	IdCliente INT4 NOT NULL,
-- 	IdEmpleadoSucursal INT4 NOT NULL,
-- 	PuntosGanados INT2 NOT NULL,
-- 	FechaCompra TIMESTAMP NOT NULL,
-- 	Toltal INT4 NOT NULL,
-- 	MetodoPago VARCHAR(50),
-- 	IdSucursal INT4 NOT NULL,
-- 	FOREIGN KEY(IdEmpleadoSucursal)
-- 		REFERENCES EmpleadoSucursal(IdEmpleadoSucursal),
-- 	FOREIGN KEY (IdCliente)
-- 		REFERENCES Cliente(IdCliente),
-- 	PRIMARY KEY (IdFactura)
-- );

-- CREATE TABLE IF NOT EXISTS ArticuloXFactura
-- (
-- 	IdArticulo INT4 NOT NULL,
-- 	IdFactura INT4 NOT NULL,
-- 	FOREIGN KEY (IdArticulo)
-- 		REFERENCES Articulo(IdArticulo),
-- 	FOREIGN KEY (IdFactura)
-- 		REFERENCES Factura(IdFactura)	
-- );


-- CREATE TABLE IF NOT EXISTS CamionXEnvio
-- (
-- 	IdCamion INT4 NOT NULL,
-- 	IdEnvio INT4 NOT NULL,
-- 	IdEmpleado INT4 NOT NULL,
-- 	FOREIGN KEY (IdCamion) 
-- 		REFERENCES Camion(IdCamion),
-- 	FOREIGN KEY (IdEnvio) 
-- 		REFERENCES Envio(IdEnvio),
-- 	FOREIGN KEY (IdEmpleado) 
-- 		REFERENCES Empleado(IdEmpleado)
-- );

-- CREATE TABLE IF NOT EXISTS CategoriaXProducto
-- (
-- 	IdProducto INT4 NOT NULL,
-- 	IdCategoria INT4 NOT NULL,
-- 	FOREIGN KEY(IdCategoria)
-- 		REFERENCES Categoria(IdCategoria),
-- 	FOREIGN KEY(IdProducto)
-- 		REFERENCES Producto(IdProducto)
-- );

-- DROP TABLE IF EXISTS Camion CASCADE; 
-- DROP TABLE IF EXISTS Tipo CASCADE;
-- DROP TABLE IF EXISTS Categoria CASCADE;
-- DROP TABLE IF EXISTS Marca CASCADE;
-- DROP TABLE IF EXISTS Genero CASCADE;
-- DROP TABLE IF EXISTS Producto CASCADE;
-- DROP TABLE IF EXISTS Articulo CASCADE; 
-- DROP TABLE IF EXISTS ArticuloEnvio CASCADE;
-- DROP TABLE IF EXISTS Envio CASCADE;
-- DROP TABLE IF EXISTS CamionXEnvio CASCADE;
-- DROP TABLE IF EXISTS Pais CASCADE;
-- DROP TABLE IF EXISTS Provincia CASCADE; 
-- DROP TABLE IF EXISTS Canton CASCADE;
-- DROP TABLE IF EXISTS Distrito CASCADE;
-- DROP TABLE IF EXISTS Ubicacion CASCADE;
-- DROP TABLE IF EXISTS Cliente CASCADE;
-- DROP TABLE IF EXISTS Persona CASCADE;
-- DROP TABLE IF EXISTS Horario CASCADE;
-- DROP TABLE IF EXISTS Empleado CASCADE;
-- DROP TABLE IF EXISTS Puesto CASCADE; 
-- DROP TABLE IF EXISTS EmpleadoMes CASCADE;
-- DROP TABLE IF EXISTS EmpleadoSucursal CASCADE;
-- DROP TABLE IF EXISTS AdministradorSucursal CASCADE;
-- DROP TABLE IF EXISTS CategoriaXProducto CASCADE;
-- DROP TABLE IF EXISTS Sucursal CASCADE;
-- DROP TABLE IF EXISTS Factura CASCADE;
-- DROP TABLE IF EXISTS CierreCaja CASCADE;
-- DROP TABLE IF EXISTS Promocion CASCADE;
-- DROP TABLE IF EXISTS PromocionXArticulo CASCADE;



-- -- Agrega los puntos de una factura al cliente.
-- CREATE OR REPLACE FUNCTION PuntosClientes() RETURNS TRIGGER AS $PuntosClientes$
--   DECLARE
--   BEGIN
--    	UPDATE Cliente
-- 	SET PuntosAcumulados = Cliente.PuntosAcumulados + NEW.PuntosGanados
-- 	WHERE
--    	NEW.IdCliente = Cliente.IdCliente;
--    RETURN NEW;
--   END;
-- $PuntosClientes$ LANGUAGE plpgsql;

-- CREATE TRIGGER PuntosClientes AFTER INSERT 
--     ON Factura FOR EACH ROW 
--     EXECUTE PROCEDURE PuntosClientes();
