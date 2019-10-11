CREATE DATABASE IF NOT EXISTS prueba;
USE prueba;

DELIMITER //
	CREATE PROCEDURE getEmpleadoMes()
    BEGIN
		SELECT E.IdEmpleado, SUM(F.Total)
			FROM Empleado E LEFT JOIN Factura F ON E.IdEmpleado = F.IdEmpleado
            GROUP BY E.IdEmpleado
            ORDER BY SUM(F.Total) DESC
            LIMIT 1	;
    END;//
DELIMITER ;

CALL getEmpleadoMes();
