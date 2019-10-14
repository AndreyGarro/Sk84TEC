
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;

public class PostgreSqlExample {

	/**
	 * Conectar con la base de datos en postgresql.
	 * 
	 * @param DBName
	 *            Nombre de la base de datos
	 * @param password
	 *            Contrseña para acceder a la base
	 * @return
	 */
	public static Connection connectDatabase(String DBName, String password) {
		Connection connection = null;
		try {
			try {
				Class.forName("org.postgresql.Driver");
			} catch (ClassNotFoundException ex) {
				System.out.println("Error al registrar el driver de PostgreSQL: " + ex);
			}
			connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/" + DBName, "postgres",
					password);

			boolean valid = connection.isValid(50000);
			System.out.println(valid ? "Valid connection" : "Fail connection");
		} catch (java.sql.SQLException sqle) {
			System.out.println("Error: " + sqle);
		}
		return connection;
	}

	/**
	 * Insertar datos a las tablas
	 * 
	 * @param tabla
	 *            Nombre de la table
	 * @param atributos
	 *            Nombre de columnas
	 * @param datos
	 *            Datos a insertar
	 * @param con
	 *            Coneccion a la base
	 */
	public static void insertData(String tabla, String atributos, String datos, Connection c) {
		try {
			Statement state = c.createStatement();
			// System.out.println("INSERT INTO " + tabla + " ("+ atributos + ")"+ " VALUES "
			// + datos);
			state.executeUpdate("INSERT INTO " + tabla + " (" + atributos + ")" + " VALUES " + datos);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Leer archivos de texto
	 * 
	 * @param fichero
	 *            Nombre y ruta del archivo
	 * @return
	 */
	public static List<String> readList(String fichero) {

		List<String> lista = new ArrayList<String>();
		try {
			File fr = new File(fichero);
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(fr), "UTF8"));
			String linea;
			while ((linea = in.readLine()) != null)
				lista.add(linea);
		} catch (Exception e) {
			System.out.println("Excepcion leyendo fichero " + fichero + ": " + e);
		}
		return lista;
	}

	/**
	 * Hacer consultas sobre datos enteros en la base de datos
	 * 
	 * @param con
	 *            Coneccion a la base
	 * @param consult
	 *            Consulta a ejecutar
	 * @param dato
	 *            Datos que queiro obtener
	 * @return Lista con el (los) dato(s)
	 */
	public static List<Integer> consultInteger(Connection con, String consult, String dato) {
		List<Integer> result = new ArrayList<Integer>();
		try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(consult)) {
			while (rs.next()) {
				result.add(rs.getInt(dato));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return result;
	}

	/**
	 * Hacer consultas sobre datos enteros en la base de datos
	 * 
	 * @param con
	 *            Coneccion a la base
	 * @param consult
	 *            Consulta a ejecutar
	 * @param dato
	 *            Datos que queiro obtener
	 * @return Lista con el (los) dato(s)
	 */
	public static List<String> consultString(Connection con, String consult, String dato) {
		List<String> result = new ArrayList<String>();
		try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(consult)) {
			while (rs.next()) {
				result.add(rs.getString(dato));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return result;
	}

	public static List<String> generateCode(String opCode, int cant) {
		Random rand = new Random();
		List<String> listaCodigos = new ArrayList<String>();

		// Carga lista para códigos
		List<String> listaAbecedario = readList("..\\data\\abecedario.txt");
		List<String> listaNumeros = readList("..\\data\\numeros.txt");

		// Longitudes de listas
		int lenAbecedario = listaAbecedario.size();
		int lenNumeros = listaNumeros.size();
		int lenCodigos = listaCodigos.size();

		String codigo;
		for (int i = 0; i < cant; i++) {
			codigo = opCode + "-" + listaAbecedario.get(rand.nextInt(lenAbecedario))
					+ listaAbecedario.get(rand.nextInt(lenAbecedario))
					+ listaAbecedario.get(rand.nextInt(lenAbecedario))
					+ listaAbecedario.get(rand.nextInt(lenAbecedario))
					+ listaAbecedario.get(rand.nextInt(lenAbecedario))
					+ listaAbecedario.get(rand.nextInt(lenAbecedario)) + listaNumeros.get(rand.nextInt(lenNumeros))
					+ listaNumeros.get(rand.nextInt(lenNumeros));

			for (String j : listaCodigos) {
				if (j == codigo) {
					codigo = "";
					i--;
					continue;
				}
			}
			listaCodigos.add(codigo);
		}

		return listaCodigos;
	}

	/**
	 * Genera detalles de ubicaciones
	 * 
	 * @return String con la informacion
	 */
	public static String generarDetalleUbicacion() {
		List<String> lugares = readList("..\\data\\lugares.txt");
		List<String> puntosCardinales = new ArrayList<String>();
		puntosCardinales.add("m norte");
		puntosCardinales.add("m sur");
		puntosCardinales.add("m este");
		puntosCardinales.add("m oeste");

		Random rand = new Random();
		String ubicacion = "";

		ubicacion = rand.nextInt(1000) + puntosCardinales.get(rand.nextInt(puntosCardinales.size())) + " "
				+ lugares.get(rand.nextInt(lugares.size()));

		return ubicacion;
	}

	/**
	 * Crea una direcion y la almacena en la base de datos.
	 * 
	 * @param c
	 *            coneccion a la base de datos
	 * @return id de la ubicación registrada
	 */
	public static Integer agregaUbicacion(Connection c) {
		Random rand = new Random();
		List<String> resStr = new ArrayList<String>();
		List<Integer> resInt = new ArrayList<Integer>();

		// Datos Pais
		List<Integer> idPais = consultInteger(c, "SELECT IdPais FROM Pais P WHERE P.Nombre = 'Costa Rica';", "IdPais");

		if (idPais.size() == 0) {
			insertData("Pais", "Nombre", "('Costa Rica');", c);
			idPais = consultInteger(c, "SELECT IdPais FROM Pais P WHERE P.Nombre = 'Costa Rica';", "IdPais");
		}

		// Datos de Provincias
		List<String> provincias = readList("..\\data\\provincias.txt");
		String provincia = provincias.get(rand.nextInt(provincias.size() - 1));
		List<Integer> idProvincia = consultInteger(c,
				"SELECT IdProvincia FROM Provincia P WHERE P.Nombre = '" + provincia + "';", "IdProvincia");

		if (idProvincia.size() == 0) {
			insertData("Provincia", "Nombre, IdPais", "('" + provincia + "'," + idPais.get(0) + ");", c);
			idProvincia = consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = '" + provincia + "';",
					"IdProvincia");
		}

		// Datos de Cantones
		List<String> cantones = readList("..\\data\\cantones_" + provincia + ".txt");
		String canton = cantones.get(rand.nextInt(cantones.size() - 1));
		List<Integer> idCanton = consultInteger(c, "SELECT IdCanton FROM Canton P WHERE P.Nombre = '" + canton + "';",
				"IdCanton");

		if (idCanton.size() == 0) {
			insertData("Canton", "Nombre, IdProvincia", "('" + canton + "'," + idProvincia.get(0) + ")", c);
			idCanton = consultInteger(c, "SELECT IdCanton FROM Canton P WHERE P.Nombre = '" + canton + "';",
					"IdCanton");
		}

		// Datos de Distritos
		List<String> distritos = readList("..\\data\\distritos_" + provincia + ".txt");
		String distrito = cantones.get(rand.nextInt(cantones.size() - 1));
		List<Integer> idDistrito = consultInteger(c,
				"SELECT IdDistrito FROM Distrito D WHERE D.Nombre = '" + distrito + "';", "IdDistrito");

		if (idDistrito.size() == 0) {
			insertData("Distrito", "Nombre, IdCanton", "('" + distrito + "', " + idCanton.get(0) + ");", c);
			idDistrito = consultInteger(c, "SELECT IdDistrito FROM Distrito D WHERE D.Nombre = '" + distrito + "';",
					"IdDistrito");
		}

		// Datos de Ubicacion
		List<String> lugares = readList("..\\data\\lugares.txt");
		List<String> pueblos = readList("..\\data\\pueblos.txt");
		String lugar = lugares.get(rand.nextInt(lugares.size() - 1));
		String pueblo = pueblos.get(rand.nextInt(pueblos.size() - 1));

		String dir = "('" + pueblo + "', '" + generarDetalleUbicacion() + "', " + idDistrito.get(0) + ");";

		insertData("Ubicacion", "NombrePueblo, DetalleUbicacion, IdDistrito", dir, c);

		return consultInteger(c, "SELECT IdUbicacion FROM Ubicacion U ORDER BY U.IdUbicacion DESC LIMIT 1;",
				"IdUbicacion").get(0);
	}

	public static Integer agregaHorarios(Connection c) {

		List<String> horarios = readList("..\\data\\horarios.txt");
		List<Integer> cantHorarios = consultInteger(c, "SELECT COUNT(*) AS Cuenta FROM Horario;", "Cuenta");

		if (horarios.size() != cantHorarios.get(0)) {
			for (int i = 0; i < horarios.size(); i++) {
				insertData("Horario", "Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo, Apertura, Cierre",
						horarios.get(i), c);
			}
		}

		return consultInteger(c, "SELECT IdHorario FROM Horario ORDER BY RANDOM() LIMIT 1", "IdHorario").get(0);
	}

	public static List<String> complementoProducto(Connection c, String genero) {
		Random rand = new Random();
		// Marcas
		List<String> marcaHombre = readList("..\\data\\marcas_hombre.txt");
		List<String> marcaMujer = readList("..\\data\\marcas_mujer.txt");

		// Tipo
		List<String> tipos_hombre = readList("..\\data\\tipos_hombre.txt");
		List<String> tipos_mujer = readList("..\\data\\tipos_mujer.txt");

		String tipo = "";
		String marca = "";
		String categoria = "";

		// Seleccionar Categoria
		List<String> listaCat = new ArrayList<String>();
		if (genero == "hombre") {
			tipo = tipos_hombre.get(rand.nextInt(tipos_hombre.size() - 1));
			marca = marcaHombre.get(rand.nextInt(marcaHombre.size() - 1));
			System.out.println(tipo);
			switch (tipo) {
			case "Abrigos":
				listaCat = readList("..\\data\\categoria_abrigos_H.txt");
				break;
			case "Camisetas":
				listaCat = readList("..\\data\\categoria_camisetas_H.txt");
				break;
			case "Jeans":
				listaCat = readList("..\\data\\categoria_jeans_H.txt");
				break;
			case "Pantalones":
				listaCat = readList("..\\data\\categoria_pantalon_H.txt");
				break;
			case "Sudaderas":
				listaCat = readList("..\\data\\categoria_sudaderas_H.txt");
				break;
			default:
				break;
			}
		} else {

			tipo = tipos_mujer.get(rand.nextInt(tipos_mujer.size() - 1));
			marca = marcaMujer.get(rand.nextInt(marcaMujer.size() - 1));
			System.out.println(tipo);

			switch (tipo) {
			case "Abrigos":
				listaCat = readList("..\\data\\categoria_abrigos_M.txt");
				break;
			case "Camisetas":
				listaCat = readList("..\\data\\categoria_camisetas_M.txt");
				break;
			case "Jeans":
				listaCat = readList("..\\data\\categoria_jeans_M.txt");
				break;
			case "Blusas":
				listaCat = readList("..\\data\\categoria_blusas_M.txt");
				break;
			case "Pantalon":
				listaCat = readList("..\\data\\categoria_pantalon_M.txt");
				break;
			case "Sudaderas":
				listaCat = readList("..\\data\\categoria_sudaderas_M.txt");
				break;
			case "Vestidos":
				listaCat = readList("..\\data\\categoria_vestidos_M.txt");
				break;
			default:
				break;
			}
		}
		List<String> temp = new ArrayList<String>();
		List<String> listaId = new ArrayList<String>();
		if (listaCat.size() > 0) {
			categoria = listaCat.get(rand.nextInt(listaCat.size() - 1));
			temp = consultString(c, "SELECT C.IdCategoria FROM Categoria C WHERE C.Categoria = '" + categoria + "';",
					"IdCategoria");

			if (temp.size() == 0) {
				insertData("Categoria", "Categoria", "('" + categoria + "');", c);
				temp = consultString(c,
						"SELECT C.IdCategoria FROM Categoria C WHERE C.Categoria = '" + categoria + "';",
						"IdCategoria");
			}

			listaId.add(temp.get(0));
		}

		temp = consultString(c, "SELECT T.idTipo FROM Tipo T WHERE T.Tipo = '" + tipo + "';", "IdTipo");

		if (temp.size() == 0) {
			insertData("Tipo", "Tipo", "('" + tipo + "');", c);
			temp = consultString(c, "SELECT T.IdTipo FROM Tipo T WHERE T.Tipo = '" + tipo + "';", "IdTipo");
		}

		listaId.add(temp.get(0));

		temp = consultString(c, "SELECT M.idMarca FROM Marca M WHERE M.Nombre = '" + marca + "';", "IdMarca");

		if (temp.size() == 0) {
			insertData("Marca", "Nombre", "('" + marca + "');", c);
			temp = consultString(c, "SELECT M.idMarca FROM Marca M WHERE M.Nombre = '" + marca + "';", "IdMarca");
		}

		listaId.add(temp.get(0));

		temp = consultString(c, "SELECT G.idGenero FROM Genero G WHERE G.Genero = '" + genero + "';", "IdGenero");
		if (temp.size() == 0) {
			insertData("Genero", "Genero", "('" + genero + "');", c);
			temp = consultString(c, "SELECT G.idGenero FROM Genero G WHERE G.Genero = '" + genero + "';", "IdGenero");
		}

		listaId.add(temp.get(0));
		return listaId;
	}

	public static String agregaProducto(Connection c, List<String> listaComplemento) {
		Random rand = new Random();
		List<String> nombre = generateCode("Name", 1);
		List<String> descripcion = generateCode("Desc", 1);

		int precio = rand.nextInt(150000) + 20000;

		List<String> estados = new ArrayList<String>();
		estados.add("Activo");
		estados.add("Inactivo");

		String estado = estados.get(rand.nextInt(estados.size() - 1));

		List<String> fechas = readList("..\\data\\fechas.txt");
		String fecha = fechas.get(rand.nextInt(fechas.size() - 1));

		int tiempoGarantia = rand.nextInt(5) + 1;

		if (listaComplemento.size() == 4) {
			insertData("Producto",
					"Nombre, Descripcion, Precio, Estado, FechaRegistro, TiempoGarantia, IdCategoria, IdTipo, IdMarca, IdGenero",
					"('" + nombre.get(0) + "', '" + descripcion.get(0) + "', " + precio + ", '" + estado + "', '"
							+ fecha + "', " + tiempoGarantia + ", " + listaComplemento.get(0) + ", "
							+ listaComplemento.get(1) + ", " + listaComplemento.get(2) + ", " + listaComplemento.get(3)
							+ ");",
					c);
		} else {
			insertData("Producto",
					"Nombre, Descripcion, Precio, Estado, FechaRegistro, TiempoGarantia, IdTipo, IdMarca, IdGenero",
					"('" + nombre.get(0) + "', '" + descripcion.get(0) + "', " + precio + ", '" + estado + "', '"
							+ fecha + "', " + tiempoGarantia + ", " + listaComplemento.get(0) + ", "
							+ listaComplemento.get(1) + ", " + listaComplemento.get(2) + ");",
					c);
		}
		return consultString(c, "SELECT idProducto FROM Producto P ORDER BY P.IdProducto DESC LIMIT 1;", "idProducto")
				.get(0);

	}

	private static String agregaPersona(Connection c, String cedula, String correo, String telefono) {
		Random rand = new Random();
		List<String> nombres = readList("..\\data\\nombres.txt");
		List<String> apellidos = readList("..\\data\\apellidos.txt");
		String nombre = nombres.get(rand.nextInt(nombres.size() - 1));
		String apellido1 = apellidos.get(rand.nextInt(apellidos.size() - 1));
		String apellido2 = apellidos.get(rand.nextInt(apellidos.size() - 1));

		insertData("Persona", "Cedula, Nombre, Apellido1, Apellido2, Email, Telefono, IdUbicacion",
				"('" + cedula + "', '" + nombre + "', '" + apellido1 + "', '" + apellido2 + "', '" + correo + "', '"
						+ telefono + "', " + agregaUbicacion(c) + ");",
				c);

		return consultString(c, "SELECT idPersona FROM Persona P ORDER BY P.idPersona DESC LIMIT 1;", "idPersona")
				.get(0);
	}

	private static String agregaPuesto(Connection c) {
		List<String> puestos = new ArrayList<String>();
		Random rand = new Random();

		puestos.add("Vendedor");
		puestos.add("Cajero");
		puestos.add("Asistente");
		puestos.add("Chofer");
		puestos.add("Gerente");
		puestos.add("Guarda");

		String puesto = puestos.get(rand.nextInt(puestos.size() - 1));

		List<String> puestoConsulta = consultString(c,
				"SELECT P.idPuesto FROM Puesto P WHERE P.Puesto = '" + puesto + "';", "idPuesto");

		if (puestoConsulta.size() == 0) {
			insertData("Puesto", "Puesto, SalarioBase", "('" + puesto + "', " + (rand.nextInt(750000) + 400000) + ");",
					c);
			puestoConsulta = consultString(c, "SELECT P.idPuesto FROM Puesto P WHERE P.Puesto = '" + puesto + "';",
					"idPuesto");
		}

		return puestoConsulta.get(0);
	}

	private static String agregaEmpleado(Connection c, String idPersona) {
		Random rand = new Random();
		List<String> fechas = readList("..\\data\\fechas.txt");
		int ptos = rand.nextInt(200);
		List<String> estados = new ArrayList<String>();
		estados.add("Activo");
		estados.add("Inactivo");
		insertData("Empleado", "Estado, FechaIngreso, Salario, IdPersona, IdHorario, IdPuesto",
				"('" + estados.get(rand.nextInt(estados.size())) + "', '" + fechas.get(rand.nextInt(fechas.size() - 1))
						+ "', " + (rand.nextInt(750) + 400) + ", " + idPersona + ", " + agregaHorarios(c) + ", "
						+ agregaPuesto(c) + ");",
				c);

		return consultString(c, "SELECT idEmpleado FROM Empleado E ORDER BY E.idEmpleado DESC LIMIT 1;", "idEmpleado")
				.get(0);
	}

	private static void relacionarEmpleadoSucursal(Connection con) {
		Random rand = new Random();
		List<String> listaEmpleados = consultString(con, "SELECT idEmpleado FROM Empleado", "idEmpleado");
		List<String> listaSucursales = consultString(con, "SELECT idSucursal FROM Sucursal", "idSucursal");

		int lenSucursales = listaSucursales.size() - 1;

		while (!listaEmpleados.isEmpty()) {
			insertData("EmpleadoSucursal", "idEmpleado, IdSucursal",
					"(" + listaEmpleados.get(0) + ", " + listaSucursales.get(rand.nextInt(lenSucursales)) + ");", con);
			listaEmpleados.remove(0);
		}
	}

	/**
	 * Main
	 * 
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		Connection c = connectDatabase("prueba", "123456789");
		Random rand = new Random();
		Integer idUbicacion = 0;
		Integer idHorario = 0;

		// Agrega Sucursales
//		for (int i = 0; i < 8; i++) {
//			idUbicacion = agregaUbicacion(c);
//			idHorario = agregaHorarios(c);
//			List<String> provincia = consultString(c,
//					"SELECT P.Nombre FROM Ubicacion U INNER JOIN Distrito D ON U.idDistrito = D.idDistrito "
//							+ "INNER JOIN Canton C ON D.idCanton = C.idCanton "
//							+ "INNER JOIN Provincia P ON P.idProvincia = C.idProvincia " + "WHERE U.IdUbicacion = "
//							+ idUbicacion,
//					"Nombre");
//
//			insertData("Sucursal", "Nombre, Descripcion, Estado, IdUbicacion, IdHorario", "('Sk8-4 TEC "
//					+ provincia.get(0) + "', 'Venta de artículos', 'Activa', " + idUbicacion + ", " + idHorario + ");",
//					c);
//		}

//		agregaProducto(c, complementoProducto(c, "hombre"));

		// Agrega persona
		List<String> cedulas = readList("..\\data\\cedulas.txt");
		List<String> correos = readList("..\\data\\email.txt");
		List<String> telefonos = readList("..\\data\\telefonos.txt");
//		
//		agregaPersona(c, cedulas.get(0), correos.get(0), telefonos.get(0));
		
		for(int i = 0; i <= 4000; i++) {
			agregaEmpleado(c, agregaPersona(c, cedulas.get(i), correos.get(i), telefonos.get(i)));
		}
	}
}