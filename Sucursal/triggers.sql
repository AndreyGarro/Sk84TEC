USE sucursal;

-- Triggers
DELIMITER //
CREATE TRIGGER PuntosClientes AFTER INSERT ON Factura
	FOR EACH ROW
	BEGIN
		UPDATE Cliente
		SET PuntosAcumulados = NEW.PuntosGanados + Cliente.PuntosAcumulados
		WHERE (NEW.IdCliente = Cliente.IdCliente); 
	END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER EstadoProducto AFTER INSERT ON ArticuloXFactura
	FOR EACH ROW
    BEGIN
		UPDATE Articulo
        SET Estado = 'En Garantía'
        WHERE (Articulo.IdArticulo = NEW.IdArticulo);
    END;//
DELIMITER ;

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

DELIMITER //
CREATE TRIGGER totalVendidoEmpleado AFTER INSERT ON Factura
	FOR EACH ROW
	BEGIN
		UPDATE Empleado
		SET totalVendido = NEW.Total + Empleado.totalVendido
		WHERE (NEW.IdEmpleado = Empleado.IdEmpleado); 
	END;//
DELIMITER ;

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
