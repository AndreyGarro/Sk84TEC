USE sucursal;

-- Funciones
DELIMITER //
CREATE FUNCTION getMejorEmpleado(inicio DATE, final DATE)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE id INT;
	SELECT E.IdEmpleado INTO id
	FROM Empleado E LEFT JOIN Factura F ON E.IdEmpleado = F.IdEmpleado
	WHERE F.FechaCompra BETWEEN inicio AND final
		GROUP BY E.IdEmpleado
		ORDER BY SUM(F.Total) DESC
	LIMIT 1;
    RETURN id;
END;//
DELIMITER ;

DELIMITER //
CREATE FUNCTION FIRST_DAY(day DATE)
RETURNS DATE DETERMINISTIC
BEGIN
  RETURN ADDDATE(LAST_DAY(SUBDATE(day, INTERVAL 1 MONTH)), 1);
END;//
DELIMITER ;

-- Procedimientos
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
	CREATE PROCEDURE getPromociones(IN fechaHora DATETIME)
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
		DECLARE empleado INT;
		SELECT E.IdEmpleado, SUM(F.Total)
			FROM Empleado E 
            INNER JOIN Factura F ON E.IdEmpleado = F.IdEmpleado
            GROUP BY E.IdEmpleado;
    END; //
DELIMITER ;

-- Cierre Caja
DELIMITER //
	CREATE PROCEDURE CierreCaja()
    BEGIN
		SET @sql_stmt := concat("SELECT F.*, AF.* FROM Factura F, articuloxfactura AF WHERE DATE(F.FechaCompra) = DATE(NOW()) AND F.IdFactura = AF.IdFactura ",
			"INTO OUTFILE 'C:/Users/Pc/Documents/Postgres/CierreCaja", CURDATE(), ".csv' ",
			"FIELDS ENCLOSED BY '", '"',"' ",
			"TERMINATED BY ", "',' ",
			"ESCAPED BY '" ,'"',"' ",
			"LINES TERMINATED BY ", "'\r\n'", ";");
			PREPARE extrct FROM @sql_stmt;
			EXECUTE extrct;
			DEALLOCATE PREPARE extrct; 	
	END; //
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE agregarCliente()
    BEGIN
		SELECT *
        FROM Cliente C, Persona PE, Ubicacion U, Distrito D, Canton CA, Provincia PR, Pais P
        WHERE (C.IdPersona = PE.IdPersona AND 
		  		PE.IdUbicacion = U.IdUbicacion AND 
		 		U.IdDistrito = D.IdDistrito AND
		 		D.IdCanton = CA.IdCanton AND
		 		CA.IdProvincia = PR.IdProvincia AND
		 		PR.IdPais = P.IdPais)
		INTO 
			OUTFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Cliente.csv"
			FIELDS TERMINATED BY ';'
			OPTIONALLY ENCLOSED BY '\"'
			LINES TERMINATED BY '\r\n';
    END; //
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE setEmpleadoMes()
    BEGIN
        DECLARE idEmpleado INT;
		SELECT getMejorEmpleado(FIRST_DAY(NOW()), LAST_DAY(NOW())) INTO idEmpleado;
        INSERT INTO EmpleadoMes(Mes, IdEmpleado)
        VALUES (FIRST_DAY(NOW()), idEmpleado);
    END;//
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE getEmpleadoMes(IN mes DATE)
    BEGIN
		SELECT P.Nombre, P.Apellido1, P.Apellido2, DATE_FORMAT(EM.Mes, '%M %Y') AS 'Mes'
        FROM Empleado E, Persona P, EmpleadoMes EM
        WHERE E.IdEmpleado = P.IdEmpleado AND
			  E.IdEmpleadoMes = EM.IdEmpleado;
    END;//
DELIMITER ;