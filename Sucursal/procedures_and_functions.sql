USE sucursal;

DELIMITER //
CREATE PROCEDURE getGarantia(IN codigo VARCHAR(50), OUT garantia DATE)
BEGIN
    SELECT FechaGarantia INTO garantia
    FROM Articulo
    WHERE Articulo.Codigo = codigo;
    SELECT garantia;
END;//
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE getPromociones(IN fechaHora DATETIME, OUT descuento VARCHAR(50), OUT articulo VARCHAR(50))
    BEGIN
		SELECT P.descuento, A.Codigo, A.Precio
        FROM Promocion P
        INNER JOIN PromocionXArticulo AP ON P.IdPromocion = AP.IdPromocion
        INNER JOIN Articulo A ON A.IdArticulo = AP.IdArticulo
		WHERE fechaHora BETWEEN P.FechaInicio AND P.FechaFinal LIMIT 2;
    END;//
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE getEmpleadoMes()
    BEGIN
		SELECT E.IdEmpleado, E.Nombre, SUM(F.Total)
			FROM Empleado E LEFT JOIN Factura F ON E.IdEmpleado = F.IdEmpleado
            GROUP BY E.IdEmpleado, E.Nombre;
    END; //
DELIMITER ;

DROP PROCEDURE CierreCaja;
-- Cierre Caja
DELIMITER //
	CREATE PROCEDURE CierreCaja()
    BEGIN
		SET @sql_stmt := concat("SELECT F.* FROM Factura F INNER JOIN ArticuloXFactura AF ON F.IdFactura = AF.IdFactura",
			"INTO OUTFILE '/Uploads/Sucursales/CierreCaja", CURDATE(), ".csv' ",
			"FIELDS ENCLOSED BY '", '"',"'",
			"TERMINATED BY ", "','",
			"ESCAPED BY '" ,'"',"'",
			"LINES TERMINATED BY ", "'\r\n'", ";");
			PREPARE extrct FROM @sql_stmt;
			EXECUTE extrct;
			DEALLOCATE PREPARE extrct;
	END; //
DELIMITER ;

CALL CierreCaja();

SELECT AF.*,F.* FROM ArticuloXFactura AF INNER JOIN Factura F ON AF.IdFactura = F.IdFactura;

DROP TABLE Factura CASCADE;
DROP TABLE ArticuloXFactura CASCADE;

CREATE TABLE IF NOT EXISTS Factura (
    IdFactura INT NOT NULL,
    FechaCompra DATETIME NOT NULL,
    PuntosGanados INT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    Total INT NOT NULL,
    IdEmpleado INT NOT NULL,
    IdCliente INT NOT NULL
);

CREATE TABLE IF NOT EXISTS ArticuloXFactura (
	IdArticulo INT NOT NULL,
    IdFactura INT NOT NULL
);

INSERT INTO Factura VALUES
(1, now(), 12, 'Tarjeta', 125, 5, 8),
(2, now(), 8, 'Tarjeta', 125, 5, 8),
(3, now(), 2, 'Efectivo', 125, 5, 8),
(4, now(), 56, 'Tarjeta', 125, 5, 8),
(5, now(), 10, 'Tarjeta', 125, 5, 8),
(6, now(), 78, 'Efectivo', 125, 5, 8);

INSERT INTO ArticuloXFactura VALUES
(1, 5),
(1, 8),
(2, 4),
(2, 3),
(2, 5),
(3, 1),
(3, 2),
(4, 10),
(4, 11),
(5, 14),
(5, 13),
(6, 17),
(6, 20),
(6, 41);

