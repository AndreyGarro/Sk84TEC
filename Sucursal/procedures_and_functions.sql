USE sucursal;

-- DELIMITER //
-- CREATE PROCEDURE getGarantia(IN codigo VARCHAR(50), OUT garantia DATE)
-- BEGIN
--     SELECT FechaGarantia INTO garantia
--     FROM Articulo
--     WHERE Articulo.Codigo = codigo;
--     SELECT garantia;
-- END;//
-- DELIMITER ;

-- DELIMITER //
-- 	CREATE PROCEDURE getPromociones(IN fechaHora DATETIME, OUT descuento VARCHAR(50), OUT articulo VARCHAR(50))
--     BEGIN
-- 		SELECT P.descuento, A.Codigo, A.Precio
--         FROM Promocion P
--         INNER JOIN PromocionXArticulo AP ON P.IdPromocion = AP.IdPromocion
--         INNER JOIN Articulo A ON A.IdArticulo = AP.IdArticulo
-- 		WHERE fechaHora BETWEEN P.FechaInicio AND P.FechaFinal LIMIT 2;
--     END;//
-- DELIMITER ;

DELIMITER //
	CREATE PROCEDURE getEmpleadoMes()
    BEGIN
		SELECT E.IdEmpleado, E.Nombre, SUM(F.Total)
			FROM Empleado E LEFT JOIN Factura F ON E.IdEmpleado = F.IdEmpleado
            GROUP BY E.IdEmpleado, E.Nombre;
    END; //
DELIMITER ;
