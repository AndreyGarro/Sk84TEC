

-- -- Consultar la garantia de un producto
-- CREATE OR REPLACE FUNCTION garantiaArticulo(IdArticuloConsult INT4) 
-- RETURNS TABLE (FechaGarantia DATE, CodigoArticulo VARCHAR(30)) AS $$
-- BEGIN
-- 	RETURN QUERY
-- 	SELECT A.FechaGarantia, A.CodigoArticulo
-- 	FROM Articulo A
-- 	WHERE A.IdArticulo = IdArticuloConsult;
-- END;
-- $$ LANGUAGE plpgsql;


-- -- Consultar promociones por fecha y hora
-- CREATE OR REPLACE FUNCTION promociones(fechaHora TIMESTAMP) 
-- RETURNS TABLE (CodigoPromocion VARCHAR(30), Descuento INT2) AS
-- $$
-- BEGIN
-- 	RETURN QUERY
-- 	SELECT P.CodigoPromocion, P.Descuento
-- 	FROM Promocion P
-- 	WHERE P.FechaFinal >= fechaHora;
-- END;
-- $$ LANGUAGE plpgsql;

-- -- Obtener el empleado del Mes
-- CREATE OR REPLACE FUNCTION getEmpleadoMes(mes DATE) 
-- RETURNS TABLE (IdSucursal INT4, IdEmpleadoSucursal INT4) AS
-- $$
-- BEGIN
-- 	RETURN QUERY
-- 	SELECT EM.IdSucursal, EM.IdEmpleadoSucursal
-- 	FROM EmpleadoMes EM
-- 	WHERE EM.Mes = mes;
-- END;
-- $$ LANGUAGE plpgsql;


	

