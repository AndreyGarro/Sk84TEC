

-- Agregar un  Articulos a la  sucursal 
/**
	Genera un CSV donde se encuentra la informacion para agregar 
	nuevos articulos a la sucursal
*/
CREATE OR REPLACE FUNCTION agregarArticulo(IdEnvioIn INT4)
RETURNS void AS $$
DECLARE
	var INT4 := IdEnvioIn;
BEGIN 
    COPY (SELECT * 
		  FROM 
		  (SELECT A.IdArticulo, A.Codigo, A.TiempoGarantia, A.IdProducto
		   FROM Articulo A 
		   INNER JOIN ArticuloEnvio AE ON A.IdArticulo = AE.IdArticulo 
		   WHERE AE.IdEnvio = var) AS ASU, Producto P, Tipo T, Marca M, Genero G, (SELECT C.IdCategoria, C.Categoria FROM Categoria C
																					   INNER JOIN CategoriaXProducto CP 
																					   ON C.IdCategoria = CP.IdCategoria) AS CA	   
		   WHERE ASU.IdProducto = P.IdProducto AND
		  		 P.IdTipo = T.IdTipo AND
		  		 P.IdMarca = M.IdMarca AND
		  		 P.IDGenero = G.IdGenero) 
	TO 'C:/Users/Pc/Documents/Postgres/ArticuloEnvio.csv' DELIMITER ',' CSV HEADER; 
END;
$$ LANGUAGE plpgsql;

SELECT * FROM agregarArticulo(4);


/**
	Function que crea una tabla con los articulos a enviar
*/
CREATE OR REPLACE FUNCTION get_all_foo() RETURNS SETOF foo AS
$BODY$
DECLARE
    r foo%rowtype;
BEGIN
    FOR r IN
        SELECT * 
		  FROM 
		  (SELECT A.IdArticulo, A.Codigo, A.TiempoGarantia, A.IdProducto
		   FROM Articulo A 
		   INNER JOIN ArticuloEnvio AE ON A.IdArticulo = AE.IdArticulo 
		   WHERE AE.IdEnvio = var) AS ASU, Producto P, Tipo T, Marca M, Genero G, (SELECT C.IdCategoria, C.Categoria FROM Categoria C
																					   INNER JOIN CategoriaXProducto CP 
																					   ON C.IdCategoria = CP.IdCategoria) AS CA	   
		   WHERE ASU.IdProducto = P.IdProducto AND
		  		 P.IdTipo = T.IdTipo AND
		  		 P.IdMarca = M.IdMarca AND
		  		 P.IDGenero = G.IdGenero > 0
    LOOP
        RETURN NEXT r;
    END LOOP;
    RETURN;
END
$BODY$
LANGUAGE plpgsql;

SELECT * FROM get_all_foo();



-- Agregar Clientes a las sucursales 
/**
	Genera un CSV donde se encuentra la informacion para agregar 
	los Clientes en la sucursal
*/
CREATE OR REPLACE PROCEDURE agregarCliente()
LANGUAGE plpgsql
AS $$
BEGIN 
    COPY (SELECT * FROM Cliente C, Persona PE, Ubicacion U, Distrito D, Canton CA, Provincia PR, Pais P
		  WHERE C.IdPersona = PE.IdPersona AND 
		  		PE.IdUbicacion = U.IdUbicacion AND 
		 		U.IdDistrito = D.IdDistrito AND
		 		D.IdCanton = CA.IdCanton AND
		 		CA.IdProvincia = PR.IdProvincia AND
		 		PR.IdPais = P.IdPais)
	TO 'C:/Users/Pc/Documents/Postgres/Clientes.csv' DELIMITER ',' CSV HEADER; 
END;
$$;

-- CALL agregarCliente();

-- Agregar Empleado a la sucursal 
/**
	Genera un CSV donde se encuentra la informacionde un nuevo empleado para 
	la sucursal
*/
CREATE OR REPLACE PROCEDURE agregarEmpleado(IdSucursal INT4)
LANGUAGE plpgsql
AS $$
BEGIN 
    COPY (SELECT * 
		  FROM (SELECT E.* FROM EMPLEADO E
			   INNER JOIN EmpleadoSucursal ES ON E.IdEmpleado = ES.IdEmpleado
			   WHERE ES.IdSucursal = IdSucursal) AS EM,
		  	   Puesto PU, Horario H, Persona PE, Ubicacion U, Distrito D, Canton CA, Provincia PR, Pais P
		  WHERE	EM.IdPuesto = PU.IdPuesto AND
		  		EM.IdHorario = H.IdHorario AND
		  		EM.IdPersona = PE.IdPersona AND 
		  		PE.IdUbicacion = U.IdUbicacion AND 
		 		U.IdDistrito = D.IdDistrito AND
		 		D.IdCanton = CA.IdCanton AND
		 		CA.IdProvincia = PR.IdProvincia AND
		 		PR.IdPais = P.IdPais)
	TO 'C:/Users/Pc/Documents/Postgres/Empleados.csv' DELIMITER ',' CSV HEADER; 
END;
$$;

