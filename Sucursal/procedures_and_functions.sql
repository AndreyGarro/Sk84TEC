USE sucursal;

-- Funciones
/**
	Busca entre todos los empleados el mejor empleado del mes
    comprando el total de las  vendas realizadas
*/
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

/**
	Obtiene el primer dia de un mes
*/
DELIMITER //
CREATE FUNCTION FIRST_DAY(day DATE)
RETURNS DATE DETERMINISTIC
BEGIN
  RETURN ADDDATE(LAST_DAY(SUBDATE(day, INTERVAL 1 MONTH)), 1);
END;//
DELIMITER ;

-- Procedimientos
/**
	Inserta el empleado del mes en la tabla,
    se ejecuta cada  final de mes
*/
DELIMITER //
	CREATE PROCEDURE setEmpleadoMes()
    BEGIN
        DECLARE idEmpleado INT;
		SELECT getMejorEmpleado(FIRST_DAY(NOW()), LAST_DAY(NOW())) INTO idEmpleado;
        INSERT INTO EmpleadoMes(Mes, IdEmpleado)
        VALUES (FIRST_DAY(NOW()), idEmpleado);
    END;//
DELIMITER ;

/**
	Obtiene la fecha de garantia de un producto indicando su codigo
*/
DELIMITER //
CREATE PROCEDURE getGarantia(IN codigo VARCHAR(50), OUT garantia DATE)
BEGIN
    SELECT FechaGarantia INTO garantia
    FROM Articulo
    WHERE Articulo.Codigo = codigo;
    SELECT garantia;
END;//
DELIMITER ;

/**
	Obtiene las promociones indicando una fecha y una hora
*/
DELIMITER //
	CREATE PROCEDURE getPromociones(IN fechaHora DATETIME)
    BEGIN
		SELECT P.descuento, A.Codigo, A.Precio
        FROM Promocion P
        INNER JOIN PromocionXArticulo AP ON P.IdPromocion = AP.IdPromocion
        INNER JOIN Articulo A ON A.IdArticulo = AP.IdArticulo
		WHERE fechaHora BETWEEN P.FechaInicio AND P.FechaFinal;
    END;//
DELIMITER ;

/**
	Consulta el empleado del mes indicando un mes especifico
*/
DELIMITER //
	CREATE PROCEDURE getEmpleadoMes(IN mes DATE)
    BEGIN
		SELECT P.Nombre, P.Apellido1, P.Apellido2, DATE_FORMAT(EM.Mes, '%M %Y') AS 'Mes'
        FROM Empleado E, Persona P, EmpleadoMes EM
        WHERE E.IdEmpleado = P.IdEmpleado AND
			  E.IdEmpleadoMes = EM.IdEmpleado;
    END;//
DELIMITER ;


-- -------------------------------------------------------------------------------
-- Procedimientos de actualizacion de la sucursal con la bodega					--
-- -------------------------------------------------------------------------------
-- Cierre Caja
/**
	Obtine todas las facturas y articulos vendidos en un dia 
    para realizar el cierre de caja al final del dia
*/
DELIMITER //
	CREATE PROCEDURE CierreCaja()
    BEGIN
		SELECT F.*, AF.* 
        FROM Factura F, articuloxfactura AF 
        WHERE DATE(F.FechaCompra) = DATE(NOW()) AND F.IdFactura = AF.IdFactura;
	END; //
DELIMITER ;

/**
	Consulta los clientes que necesitan que los agregen o que  los actualicen 
    y los envia a la Bodega
*/
DELIMITER //
	CREATE PROCEDURE agregarCliente()
    BEGIN
		SELECT *
        FROM Cliente C, Persona PE, Ubicacion U, Distrito D, Canton CA, Provincia PR, Pais P
        WHERE C.IdPersona = PE.IdPersona AND 
		  		PE.IdUbicacion = U.IdUbicacion AND 
		 		U.IdDistrito = D.IdDistrito AND
		 		D.IdCanton = CA.IdCanton AND
		 		CA.IdProvincia = PR.IdProvincia AND
		 		PR.IdPais = P.IdPais AND 
                C.Actualizar = 1;
    END; //
DELIMITER ;