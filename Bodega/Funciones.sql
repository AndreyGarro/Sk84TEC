

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
	

