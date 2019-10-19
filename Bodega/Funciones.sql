

/**
	Consultar la garantia de un producto
*/
-- Consultar la garantia de un producto
CREATE OR REPLACE FUNCTION garantiaArticulo(IdArticuloConsult INT4) 
RETURNS TABLE (FechaGarantia DATE, CodigoArticulo VARCHAR(30)) AS $$
BEGIN
	RETURN QUERY
	SELECT A.FechaGarantia, A.Codigo
	FROM Articulo A
	WHERE A.IdArticulo = IdArticuloConsult;
END;
$$ LANGUAGE plpgsql;

--SELECT * FROM garantiaArticulo(2);

/**
	Obtener las promociones por fehca y hora
*/
-- Consultar promociones por fecha y hora
CREATE OR REPLACE FUNCTION promociones(fechaHora TIMESTAMP) 
RETURNS TABLE (CodigoPromocion VARCHAR(30), Descuento INT2) AS
$$
BEGIN
	RETURN QUERY
	SELECT P.Codigo, P.Descuento
	FROM Promocion P
	WHERE fechaHora BETWEEN P.FechaInicio AND P.FechaFinal;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM promociones('2019-10-15 00:00:00');

/**
	Obtiene el empleado del Mes indicando el mes como un CHAR, ej('06')
*/
CREATE OR REPLACE FUNCTION getEmpleadoMes(mesIn char) 
RETURNS TABLE (IdSucursal INT4, IdEmpleadoSucursal INT4) AS
$$
BEGIN
	RETURN QUERY
	SELECT EM.IdSucursal, EM.IdEmpleadoSucursal
	FROM EmpleadoMes EM
	WHERE to_char(EM.Mes, 'Month') = mesIn;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM getEmpleadoMes('09');

-- DROP FUNCTION IF EXISTS garantiaArticulo;
-- DROP FUNCTION IF EXISTS getEmpleadoMes;
-- DROP FUNCTION IF EXISTS promociones;

-------------------------------------------
-- Agregar un cliente desde las sucursales
-------------------------------------------


/**
	Agregar una Ubicacion completa
*/
CREATE OR REPLACE PROCEDURE insertarUbicacion(NombrePueblo VARCHAR(50), DetalleUbicacion VARCHAR(255), NombreDistrito VARCHAR(50),	
										   NombreCanton VARCHAR(50), NombreProvincia VARCHAR(50), NombrePais VARCHAR(50))
LANGUAGE SQL 
AS $$
	INSERT INTO Pais (Nombre) SELECT NombrePais
	WHERE NOT EXISTS (SELECT IdPais FROM Pais WHERE Nombre = NombrePais);
	
	INSERT INTO Provincia (Nombre, IdPais) SELECT NombreProvincia, (SELECT IdPais FROM Pais WHERE Nombre = NombrePais LIMIT 1)
	WHERE NOT EXISTS (SELECT IdProvincia FROM Provincia WHERE Nombre = NombreProvincia);

	INSERT INTO Canton (Nombre, IdProvincia) SELECT NombreCanton, (SELECT IdProvincia FROM Provincia WHERE Nombre = NombreProvincia LIMIT 1)
	WHERE NOT EXISTS (SELECT IdCanton FROM Canton WHERE Nombre = NombreCanton);
	
	INSERT INTO Distrito (Nombre, IdCanton) SELECT NombreDistrito, (SELECT IdCanton FROM Canton WHERE Nombre = NombreCanton LIMIT 1)
	WHERE NOT EXISTS (SELECT IdDistrito FROM Distrito WHERE Nombre = NombreDistrito);
	
	INSERT INTO Ubicacion (NombrePueblo, DetalleUbicacion, IdDistrito) SELECT NombrePueblo, DetalleUbicacion, (SELECT IdDistrito 
																											  FROM Distrito WHERE Nombre = NombreDistrito)
	WHERE NOT EXISTS (SELECT IdUbicacion FROM Ubicacion U WHERE U.NombrePueblo = NombrePueblo AND U.DetalleUbicacion =  DetalleUbicacion);
$$;



SELECT * FROM Pais;
SELECT * FROM Provincia;
SELECT * FROM Canton;
SELECT * FROM Distrito;
SELECT * FROM Ubicacion;
