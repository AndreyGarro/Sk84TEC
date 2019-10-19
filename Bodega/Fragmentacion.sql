

-- Agregar un  Articulos a la  sucursal 
/**
	Genera un CSV donde se encuentra la informacion para agregar 
	nuevos articulos a la sucursal
*/
CREATE OR REPLACE FUNCTION agregarArticulo(IdEnvioIn INT4)
RETURNS TABLE (IdArticulo INT4, FechaIngreso DATE, Codigo VARCHAR(30), TiempoGarantia INT4, Estado VARCHAR(50), Precio1 INT4, IdSucursal INT4, IdProducto INT4,
			  IdProducto1 INT4, Nombre2 VARCHAR(100), Descripcion VARCHAR(255), Precio INT4, Estado1 VARCHAR(30), FechaRegistro TIMESTAMP, IdCategria INT4, IdTipo INT4, IdMarca INT4, IdGenero INT4,
			  IdTipo1 INT4, Tipo VARCHAR(50), IdMarca1 INT4, Nombre VARCHAR(50), IdGenero1 INT4, Genero VARCHAR(30), IdCategoria1 INT4, Categoria VARCHAR(50)) AS 
$$
BEGIN 
	RETURN QUERY
		SELECT ASU.IdArticulo, ASU.FechaIngreso, ASU.Codigo, ASU.TiempoGarantia, ASU.Estado, ASU.Precio, ASU.IdSucursal, ASU.IdProducto,
			  P.IdProducto, P.Nombre, P.Descripcion, P.Precio, P.Estado, P.FechaRegistro, P.IdCategoria, P.IdTipo, P.IdMarca, P.IdGenero,
			  T.IdTipo, T.Tipo, M.IdMarca, M.Nombre, G.IdGenero, G.Genero, C.IdCategoria, C.Categoria
		  FROM 
		  (SELECT A.IdArticulo, A.FechaIngreso, A.Codigo, A.TiempoGarantia, A.Estado, A.Precio, A.IdSucursal, A.IdProducto
		   FROM Articulo A INNER JOIN ArticuloEnvio AE ON A.IdArticulo = AE.IdArticulo 
		   WHERE AE.IdEnvio = IdEnvio) AS ASU, Producto P, Tipo T, Marca M, Genero G, Categoria C	   
		   WHERE C.IdCategoria = P.IdCategoria AND
		  		 P.IdTipo = T.IdTipo AND
		  		 P.IdMarca = M.IdMarca AND
		  		 P.IDGenero = G.IdGenero; 
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM agregarArticulo(4);

-- Agregar Clientes a las sucursales 
/**
	Genera un CSV donde se encuentra la informacion para agregar 
	los Clientes en la sucursal
*/
CREATE OR REPLACE FUNCTION agregarCliente() 
RETURNS TABLE (IdCliente INT4, PuntosAcumulados INT4, FechaRegistro DATE, IdPersona INT4,
				IdPersona1 INT4, Cedula VARCHAR(50), Nombre VARCHAR(50), Apellido1 VARCHAR(50), Apellido2 VARCHAR(50), Email VARCHAR(50), Telefono VARCHAR(50), IdUbicacion INT4,
				IdUbicacion1 INT4, NombrePueblo VARCHAR(50), DetalleUbicacion VARCHAR(255), IdDistrito INT4,
				IdDistrito1 INT4, Nombre1 VARCHAR(50), IdCanton INT4,
				IdCanton1 INT4, Nombre2 VARCHAR(50), IdProvincia INT4, 
				IdProvincia1 INT4, Nombre3 VARCHAR(50), IdPais INT4,
				IdPais1 INT4, Nombre4 VARCHAR(50)) AS 
$$
BEGIN 
	RETURN QUERY
		SELECT C.IdCliente, C.PuntosAcumulados, C.FechaRegistro, C.IdPersona,
				PE.IdPersona, PE.Cedula, PE.Nombre, PE.Apellido1, PE.Apellido2, PE.Email, PE.Telefono, PE.IdUbicacion,
				U.IdUbicacion, U.NombrePueblo, U.DetalleUbicacion, U.IdDistrito,
				D.IdDistrito, D.Nombre, D.IdCanton,
				CA.IdCanton, CA.Nombre, CA.IdProvincia, 
				PR.IdProvincia, PR.Nombre, PR.IdPais,
				P.IdPais, P.Nombre
		FROM Cliente C, Persona PE, Ubicacion U, Distrito D, Canton CA, Provincia PR, Pais P
			  WHERE C.IdPersona = PE.IdPersona AND 
					PE.IdUbicacion = U.IdUbicacion AND 
					U.IdDistrito = D.IdDistrito AND
					D.IdCanton = CA.IdCanton AND
					CA.IdProvincia = PR.IdProvincia AND
					PR.IdPais = P.IdPais AND
					C.Actualizar = 1;
END;
$$ 
LANGUAGE plpgsql;

-- SELECT * FROM agregarCliente();
-- DROP FUNCTION agregarCliente;

-- Agregar Empleado a la sucursal 
/**
	Genera un table donde se encuentra la informacion de los nuevos empleados para 
	la sucursal en un dia.
*/
CREATE OR REPLACE FUNCTION agregarEmpleado(IdSucursalIN INT4)
RETURNS TABLE (IdEmpleado INT4, Estado VARCHAR(20), FechaIngreso DATE, Salario INT4, IdPersona INT4, IdHorario INT4,  IdPuesto INT4,
				IdPuesto1 INT4, Puesto VARCHAR(100), SalarioBase INT4,
				IdHorario1 INT4, Lunes BOOL, Martes BOOL, Miercoles BOOL, Jueves BOOL, Viernes BOOL, Sabado BOOL, Domingo BOOL, Apertura TIME, Cierre TIME,
				IdPersona1 INT4, Cedula VARCHAR(50), Nombre VARCHAR(50), Apellido1 VARCHAR(50), Apellido2 VARCHAR(50), Email VARCHAR(50), Telefono VARCHAR(50), IdUbicacion INT4,
				IdUbicacion1 INT4, NombrePueblo VARCHAR(50), DetalleUbicacion VARCHAR(255), IdDistrito INT4,
				IdDistrito1 INT4, Nombre1 VARCHAR(50), IdCanton INT4,
				IdCanton1 INT4, Nombre2 VARCHAR(50), IdProvincia INT4, 
				IdProvincia1 INT4, Nombre3 VARCHAR(50), IdPais INT4,
				IdPais1 INT4, Nombre4 VARCHAR(50)) AS 
$$
BEGIN 
	RETURN QUERY
		SELECT 	EM.IdEmpleado, EM.Estado, EM.FechaIngreso, EM.Salario, EM.IdPersona, EM.IdHorario, EM.IdPuesto,
				PU.IdPuesto, PU.Puesto, PU.SalarioBase,
				H.IdHorario, H.Lunes, H.Martes, H.Miercoles, H.Jueves, H.Viernes, H.Sabado, H.Domingo, H.Apertura, H.Cierre,
				PE.IdPersona, PE.Cedula, PE.Nombre, PE.Apellido1, PE.Apellido2, PE.Email, PE.Telefono, PE.IdUbicacion,
				U.IdUbicacion, U.NombrePueblo, U.DetalleUbicacion, U.IdDistrito,
				D.IdDistrito, D.Nombre, D.IdCanton,
				CA.IdCanton, CA.Nombre, CA.IdProvincia, 
				PR.IdProvincia, PR.Nombre, PR.IdPais,
				P.IdPais, P.Nombre 
			  FROM (SELECT E.* FROM EMPLEADO E
				   INNER JOIN EmpleadoSucursal ES ON E.IdEmpleado = ES.IdEmpleado
				   WHERE ES.IdSucursal = IdSucursalIN) AS EM,
				   Puesto PU, Horario H, Persona PE, Ubicacion U, Distrito D, Canton CA, Provincia PR, Pais P
			  WHERE	EM.IdPuesto = PU.IdPuesto AND
					EM.IdHorario = H.IdHorario AND
					EM.IdPersona = PE.IdPersona AND 
					PE.IdUbicacion = U.IdUbicacion AND 
					U.IdDistrito = D.IdDistrito AND
					D.IdCanton = CA.IdCanton AND
					CA.IdProvincia = PR.IdProvincia AND
					PR.IdPais = P.IdPais AND
					DATE_PART('year', EM.FechaIngreso) = '2019'; 
END;
$$ 
LANGUAGE plpgsql;

-- SELECT * FROM agregarEmpleado(2);


