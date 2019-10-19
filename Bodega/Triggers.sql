
/**
	Agrega los puntos de una factura al cliente
*/
CREATE OR REPLACE FUNCTION PuntosClientes() RETURNS TRIGGER AS $PuntosClientes$
  DECLARE
  BEGIN
   	UPDATE Cliente
	SET PuntosAcumulados = Cliente.PuntosAcumulados + NEW.PuntosGanados
	WHERE
   	NEW.IdCliente = Cliente.IdCliente;
   RETURN NEW;
  END;
$PuntosClientes$ LANGUAGE plpgsql;
-- Se activa cada insersiones de las facturas 
CREATE TRIGGER PuntosClientes AFTER INSERT 
    ON Factura FOR EACH ROW 
    EXECUTE PROCEDURE PuntosClientes();

/**
	Cambiar el estado de un producto cada vez que se agrega una factura con el articulo 
*/
CREATE OR REPLACE FUNCTION estadoProducto() RETURNS TRIGGER AS $EstadoProducto$
  DECLARE
  BEGIN
   	UPDATE Articulo
		SET Estado = 'Garantia'
		WHERE NEW.IdCliente = Cliente.IdCliente;
   	RETURN NEW;
  END;
$EstadoProducto$ 
LANGUAGE plpgsql;

CREATE TRIGGER estadoProducto AFTER INSERT 
    ON ArticuloXFactura FOR EACH ROW 
    EXECUTE PROCEDURE estadoProducto();

/**
 	Agregar el id_sucursal a los articulos cuando se envian.
*/
CREATE OR REPLACE FUNCTION asignarArticulo() RETURNS TRIGGER AS $AsignarArticulo$
  DECLARE
  BEGIN
	UPDATE Articulo
	SET IdSucursal = E.IdSucursal, Estado = 'Inventario'
	FROM Envio E
	WHERE E.IdEnvio = NEW.IdEnvio AND IdArticulo = NEW.IdArticulo;
	RETURN NEW;
  END;
$AsignarArticulo$ LANGUAGE plpgsql;

CREATE TRIGGER asignarArticulo AFTER INSERT 
    ON ArticuloEnvio FOR EACH ROW 
    EXECUTE PROCEDURE asignarArticulo();

-- DROP TRIGGER IF EXISTS PuntosClientes ON Factura CASCADE;
-- DROP TRIGGER IF EXISTS estadoProducto ON ArticuloXFactura CASCADE;
-- DROP TRIGGER IF EXISTS asignarArticulo ON ArticuloEnvio CASCADE;

