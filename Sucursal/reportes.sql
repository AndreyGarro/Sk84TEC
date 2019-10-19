/**
	Reporte sobre puntos de clientes.
*/
DELIMITER //
	CREATE PROCEDURE puntosClientesCSV()
    BEGIN
		SET @sql_stmt := concat("SELECT P.Nombre, C.PuntosAcumulados, C.IdCliente FROM Cliente C INNER JOIN Persona P ON C.IdPersona = P.IdPersona ",
			"INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/puntosClientes", CURDATE(),"-",HOUR(NOW()),"-",MINUTE(NOW()),"-",SECOND(NOW()), ".csv' ",
			"FIELDS ENCLOSED BY '", '"',"' ",
			"TERMINATED BY ", "',' ",
			"ESCAPED BY '" ,'"',"' ",
			"LINES TERMINATED BY ", "'\r\n'", ";");
			PREPARE extrct FROM @sql_stmt;
			EXECUTE extrct;
			DEALLOCATE PREPARE extrct; 	
	END; //
DELIMITER ;

-- CALL puntosClientesCSV();

/**
 Reporte sobre cantidad de productos actuales en el inventario de la tienda, de
los productos vendidos, de productos en garantía
*/
DELIMITER //
	CREATE PROCEDURE estadoArticulosCSV()
    BEGIN
		SET @sql_stmt := concat("SELECT 
(SELECT COUNT(*) FROM Articulo A LEFT JOIN ArticuloXFactura AF ON A.IdArticulo = AF.IdArticulo WHERE A.FechaGarantia = NULL) AS ArticulosInventario,
(SELECT COUNT(*) FROM ArticuloXFactura) AS ArticulosVendidos,
(SELECT COUNT(*)  FROM Articulo A WHERE A.Estado = 'En Garantía' ) AS ArticulosGarantia ",
			"INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/estadoArticulos", CURDATE(),"-",HOUR(NOW()),"-",MINUTE(NOW()),"-",SECOND(NOW()), ".csv' ",
			"FIELDS ENCLOSED BY '", '"',"' ",
			"TERMINATED BY ", "',' ",
			"ESCAPED BY '" ,'"',"' ",
			"LINES TERMINATED BY ", "'\r\n'", ";");
			PREPARE extrct FROM @sql_stmt;
			EXECUTE extrct;
			DEALLOCATE PREPARE extrct; 	
	END; //
DELIMITER ;

-- CALL estadoArticulosCSV();
	
/**
	Reporte de las compras realizadas
*/
DELIMITER //
	CREATE PROCEDURE comprasCSV()
    BEGIN
		SET @sql_stmt := concat("SELECT * FROM Factura F GROUP BY(DATE(F.FechaCompra)) ",
			"INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/comprasCSV", CURDATE(),"-",HOUR(NOW()),"-",MINUTE(NOW()),"-",SECOND(NOW()), ".csv' ",
			"FIELDS ENCLOSED BY '", '"',"' ",
			"TERMINATED BY ", "',' ",
			"ESCAPED BY '" ,'"',"' ",
			"LINES TERMINATED BY ", "'\r\n'", ";");
			PREPARE extrct FROM @sql_stmt;
			EXECUTE extrct;
			DEALLOCATE PREPARE extrct; 	
	END; //
DELIMITER ;

 -- CALL comprasCSV();
