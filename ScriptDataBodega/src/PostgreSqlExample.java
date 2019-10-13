
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
	 * @param c coneccion a la base de datos
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
		
		if(horarios.size() != cantHorarios.get(0)) {
			for (int i = 0; i < horarios.size(); i++) {
				insertData("Horario", "Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo, Apertura, Cierre",
						horarios.get(i), c);
			}
		}

		return consultInteger(c, "SELECT IdHorario FROM Horario ORDER BY RANDOM() LIMIT 1", "IdHorario").get(0);
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

		for (int i = 0; i < 8; i++) {
			idUbicacion = agregaUbicacion(c);
			idHorario = agregaHorarios(c);
			System.out.println("SELECT P.Nombre FROM Ubicacion U INNER JOIN Distrito D ON U.idDistrito = D.idDistrito "
					+ "INNER JOIN Canton C ON D.idCanton = C.idCanton "
					+ "INNER JOIN Provincia P ON P.idProvincia = C.idProvincia "
					+ "WHERE U.IdUbicacion = " + idUbicacion);
			List<String> provincia = consultString(c,
					"SELECT P.Nombre FROM Ubicacion U INNER JOIN Distrito D ON U.idDistrito = D.idDistrito "
					+ "INNER JOIN Canton C ON D.idCanton = C.idCanton "
					+ "INNER JOIN Provincia P ON P.idProvincia = C.idProvincia "
					+ "WHERE U.IdUbicacion = " + idUbicacion, "Nombre");
			
			insertData("Sucursal", "Nombre, Descripcion, Estado, IdUbicacion, IdHorario",
					"('Sk8-4 TEC " + provincia.get(0) +"', 'Venta de artículos', 'Activa', " + idUbicacion + ", " + idHorario + ");", c);
		}

	}
}