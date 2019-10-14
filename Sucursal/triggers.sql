USE sucursal;

-- Triggers
/**
	Se activa en cada factura para actualizar los puntos de los clientes.
*/
DELIMITER //
CREATE TRIGGER PuntosClientes AFTER INSERT ON Factura
	FOR EACH ROW
	BEGIN
		UPDATE Cliente
		SET PuntosAcumulados = NEW.PuntosGanados + Cliente.PuntosAcumulados
		WHERE (NEW.IdCliente = Cliente.IdCliente); 
	END;//
DELIMITER ;

/**
	Actualiza el estado del producto cuando es vendido
*/
DELIMITER //
CREATE TRIGGER EstadoProducto AFTER INSERT ON ArticuloXFactura
	FOR EACH ROW
    BEGIN
		UPDATE Articulo
        SET Estado = 'En Garantía'
        WHERE (Articulo.IdArticulo = NEW.IdArticulo);
    END;//
DELIMITER ;

/**
	Inserta la fecha de garantia al articulo cuando es vendido
*/
DELIMITER //
CREATE TRIGGER setGarantia AFTER INSERT ON ArticuloXFactura
	FOR EACH ROW
	BEGIN
		DECLARE fecha DATETIME;
		SELECT FechaCompra INTO fecha
        FROM Factura
        WHERE ArticuloXFactura.IdFactura = Factura.IdFactura;
		UPDATE Articulo
			SET FechaGarantia = date_add(fecha, INTERVAL Articulo.TiempoGarantia MONTH)
            WHERE NEW.IdArticulo = Articulo.IdArticulo;
    END;//
DELIMITER ;


-- Eventos
/**
	Evento que se activa una vez al para  insertar
    el empleado del mes.
*/
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

/**
	Evento cierre de caja se activa todas las noches a las 
    10:00 pm.
*/
DELIMITER //
	CREATE EVENT cierreCaja
    ON SCHEDULE EVERY 1 DAY
    STARTS '2015-01-01 22:00:00'
    ON COMPLETION PRESERVE
    DO
		BEGIN
			CALL CierreCaja();
		END;//
DELIMITER ;
