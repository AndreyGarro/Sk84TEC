CREATE DATABASE IF NOT EXISTS prueba;
USE prueba;

CREATE TABLE IF NOT EXISTS Factura (
    IdFactura INT NOT NULL AUTO_INCREMENT,
    FechaCompra DATETIME NOT NULL,
    Total INT NOT NULL,
    IdEmpleado INT NOT NULL,
    PRIMARY KEY (IdFactura),
    FOREIGN KEY (IdEmpleado)
        REFERENCES Empleado (IdEmpleado)
);

DELIMITER //
	CREATE PROCEDURE getPromocion(IN fechaHora DATETIME)
    BEGIN
		SELECT P.descuento, A.IdArticulo
        FROM Promocion P
        INNER JOIN PromocionXArticulo AP ON P.IdPromocion = AP.IdPromocion
        INNER JOIN Articulo A ON A.IdArticulo = AP.IdArticulo
		WHERE fechaHora BETWEEN P.FechaInicio AND P.FechaFinal LIMIT 2;
    END;//
DELIMITER ;

INSERT INTO Factura(FechaCompra, Total, IdEmpleado) VALUES
	('2019-10-04', 600000, 2);

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

CREATE TABLE EmpleadoMes(
	IdEmpleadoMes INT NOT NULL AUTO_INCREMENT,
    Mes DATE NOT NULL,
    IdEmpleado INT NOT NULL,
    PRIMARY KEY (IdEmpleadoMes),
    FOREIGN KEY (IdEmpleado)
        REFERENCES Empleado (IdEmpleado)
);

DELIMITER //
CREATE FUNCTION FIRST_DAY(day DATE)
RETURNS DATE DETERMINISTIC
BEGIN
  RETURN ADDDATE(LAST_DAY(SUBDATE(day, INTERVAL 1 MONTH)), 1);
END;//
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

DELIMITER //
	CREATE PROCEDURE getEmpleadoMes(IN mes DATE)
    BEGIN
		SELECT E.IdEmpleado, DATE_FORMAT(EM.Mes, '%M %Y') AS 'Mes'
        FROM Empleado E, EmpleadoMes EM
        WHERE E.IdEmpleado = EM.IdEmpleado;
    END;//
DELIMITER ;

CALL getEmpleadoMes(curdate())

-- Eventos
DELIMITER //
CREATE EVENT seleccionaEmpleadoMes
ON SCHEDULE EVERY 1 MONTH
STARTS current_date()
ON COMPLETION PRESERVE
DO
	BEGIN
		CALL setEmpleadoMes();
    END;//
DELIMITER ;

DROP EVENT seleccionaEmpleadoMes;

SELECT * FROM EmpleadoMes;