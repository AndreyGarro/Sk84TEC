

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
  
	/** Conectar con la base de datos en postgresql.
     * 
     * @param DBName Nombre de la base de datos
     * @param password Contrseña para acceder a la base
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
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/" + DBName, "postgres", password);

            boolean valid = connection.isValid(50000);
            System.out.println(valid ? "Valid connection" : "Fail connection");
        } catch (java.sql.SQLException sqle) {
            System.out.println("Error: " + sqle);
        }
        return connection;
    } 
    
	/**
	 * Insertar datos a las tablas
	 * @param tabla Nombre de la table
	 * @param atributos Nombre de columnas
	 * @param datos Datos a insertar
	 * @param con Coneccion a la base
	 */
	public static void insertData(String tabla, String atributos, String datos, Connection c) {
		try {
			Statement state = c.createStatement();
			state.executeUpdate("INSERT INTO " + tabla + " ("+ atributos + ")"+ " VALUES " + datos);
//			System.out.println("INSERT INTO " + tabla + " ("+ atributos + ")"+ " VALUES " + datos);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Leer archivos de texto 
	 * @param fichero Nombre y ruta del archivo 
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
	 * @param con Coneccion a la base
	 * @param consult Consulta a ejecutar
	 * @param dato Datos que queiro obtener
	 * @return Lista con el (los) dato(s)
	 */
	public static List<Integer> consultInteger(Connection con, String consult, String dato) {
        List<Integer> result = new ArrayList<Integer>();
        try (Statement stmt  = con.createStatement();
             ResultSet rs    = stmt.executeQuery(consult)){
            while (rs.next()) {
                result.add(rs.getInt(dato));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return result;
    }
	
	/**
	 * Genera detalles de ubicaciones 
	 * @return String con la informacion
	 */
	public static String generarDetalleUbicacion() {
		List<String> lugares = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\lugares.txt");
		List<String> puntosCardinales = new ArrayList<String>();
		puntosCardinales.add("m norte");
		puntosCardinales.add("m sur");
		puntosCardinales.add("m este");
		puntosCardinales.add("m oeste");
		
		Random rand = new Random();  
		String ubicacion = "";
		
		ubicacion =  	   rand.nextInt(1000) + " "
						 + puntosCardinales.get(rand.nextInt(puntosCardinales.size())) + " "
						 + lugares.get(rand.nextInt(lugares.size()));
		
		return ubicacion;
    }
	/**
	 * Main
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		Connection c = connectDatabase("ProyectoUno", "12345678");
		Random rand = new Random();
		
//--------------------------------------------------------------------------------------------//
		//Cargar Paises
		String datosPaises = "";
		datosPaises += " ('Costa Rica');";
		
//		insertData("Pais", "Nombre", datosPaises, c );

//--------------------------------------------------------------------------------------------//
		//Cargar Provincias
		List<String> provincias = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\provincias.txt");
		List<Integer> idPaises =  consultInteger(c, "SELECT IdPais FROM Pais", "IdPais");
		
		String datosProvincias = "";
		for(int i = 0; i < provincias.size(); i++) {
			if (i == provincias.size() - 1) {
				datosProvincias += "(\'" + provincias.get(i) + "\'," 
						+ idPaises.get(rand.nextInt(idPaises.size())) + ");";
			}else {
				datosProvincias += "(\'" + provincias.get(i) + "\'," 
						+ idPaises.get(rand.nextInt(idPaises.size())) + "),\n";
			}
		}
//		insertData("Provincia", "Nombre, IdPais", datosProvincias, c);
//--------------------------------------------------------------------------------------------//
		//Cargar Cantones
		List<String> cantonesSJ = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_san_jose.txt");
		List<Integer> idProvinciaSJ =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'San José' ", "IdProvincia");
		
		List<String> cantonesH = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_heredia.txt");
		List<Integer> idProvinciaH =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Heredia' ", "IdProvincia");
		
		List<String> cantonesA = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_alajuela.txt");
		List<Integer> idProvinciaA =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Alajuela' ", "IdProvincia");
		
		List<String> cantonesC = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_cartago.txt");
		List<Integer> idProvinciaC =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Cartago' ", "IdProvincia");
		
		List<String> cantonesP = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_puntarenas.txt");
		List<Integer> idProvinciaP =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Puntarenas' ", "IdProvincia");
		
		List<String> cantonesL = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_limon.txt");
		List<Integer> idProvinciaL =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Limón' ", "IdProvincia");
		
		List<String> cantonesG = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\cantones_guanacaste.txt");
		List<Integer> idProvinciaG =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Guanacaste' ", "IdProvincia");
		
		String datosCantones = "";
		for(int i = 0; i < cantonesSJ.size(); i++) {
			datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaSJ.get(0) + "),\n";
		}
		for(int i = 0; i < cantonesH.size(); i++) {
			datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaH.get(0) + "),\n";
		}
		for(int i = 0; i < cantonesA.size(); i++) {
			datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaA.get(0) + "),\n";
		}
		for(int i = 0; i < cantonesC.size(); i++) {
			datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaC.get(0) + "),\n";
		}
		for(int i = 0; i < cantonesP.size(); i++) {
			datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaP.get(0) + "),\n";
		}
		for(int i = 0; i < cantonesL.size(); i++) {
			datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaL.get(0) + "),\n";
		}
		for(int i = 0; i < cantonesG.size(); i++) {
			if( i == cantonesG.size() - 1) {
				datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
						+ idProvinciaG.get(0) + ");";
			}
			else{ datosCantones += "(\'" + cantonesSJ.get(i) + "\'," 
					+ idProvinciaG.get(0) + "),\n";}
		}
//		insertData("Canton", "Nombre, IdProvincia", datosCantones, c);
//--------------------------------------------------------------------------------------------//
		//Carga distritos
		List<String> distritosSJ = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_san_jose.txt");
		List<Integer> idCantonesSJ =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'San José'", "IdCanton");
		
		List<String> distritosA = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_alajuela.txt");
		List<Integer> idCantonesA =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Alajuela'", "IdCanton");
		
		List<String> distritosC = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_cartago.txt");
		List<Integer> idCantonesC =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Cartago'", "IdCanton");
		
		List<String> distritosG = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_guanacaste.txt");
		List<Integer> idCantonesG =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Guanacaste'", "IdCanton");
		
		List<String> distritosH = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_heredia.txt");
		List<Integer> idCantonesH =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Heredia'", "IdCanton");
		
		List<String> distritosL = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_limon.txt");
		List<Integer> idCantonesL =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Limón'", "IdCanton");
		
		List<String> distritosP = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\distritos_puntarenas.txt");
		List<Integer> idCantonesP =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Puntarenas'", "IdCanton");

		String datosDistritos = "";
		for(int i = 0; i < distritosSJ.size(); i++) {
			datosDistritos += "(\'" + distritosSJ.get(i) + "\'," 
					+ idCantonesSJ.get(rand.nextInt(idCantonesSJ.size())) + "),\n";
		}
		for(int i = 0; i < distritosA.size(); i++) {
			datosDistritos += "(\'" + distritosA.get(i) + "\'," 
					+ idCantonesA.get(rand.nextInt(idCantonesA.size())) + "),\n";
		}
		for(int i = 0; i < distritosC.size(); i++) {
			datosDistritos += "(\'" + distritosC.get(i) + "\'," 
					+ idCantonesC.get(rand.nextInt(idCantonesC.size())) + "),\n";
		}
		for(int i = 0; i < distritosG.size(); i++) {
			datosDistritos += "(\'" + distritosG.get(i) + "\'," 
					+ idCantonesG.get(rand.nextInt(idCantonesG.size())) + "),\n";
		}
		for(int i = 0; i < distritosH.size(); i++) {
			datosDistritos += "(\'" + distritosH.get(i) + "\'," 
					+ idCantonesH.get(rand.nextInt(idCantonesH.size())) + "),\n";
		}
		for(int i = 0; i < distritosL.size(); i++) {
			datosDistritos += "(\'" + distritosL.get(i) + "\'," 
					+ idCantonesL.get(rand.nextInt(idCantonesL.size())) + "),\n";
		}
		for(int i = 0; i < distritosP.size(); i++) {
			if( i == distritosP.size() - 1) {
				datosDistritos += "(\'" + distritosP.get(i) + "\'," 
						+ idCantonesP.get(rand.nextInt(idCantonesP.size())) + ");";
			}
			else{ 
				datosDistritos += "(\'" + distritosP.get(i) + "\'," 
					+ idCantonesP.get(rand.nextInt(idCantonesP.size())) + "),\n";}
		}
//		insertData("Distrito", "Nombre, IdCanton", datosDistritos, c);
//--------------------------------------------------------------------------------------------//
		//Cargar Ubicaciones
		List<String> pueblos = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\pueblos.txt");
		List<Integer> idDistritos =  consultInteger(c, "SELECT IdDistrito FROM Distrito", "IdDistrito");
		
		String datosUbicaciones = "";
		int NUM_UBICACIONES = 4000;
		for (int i = 0; i < NUM_UBICACIONES; i++) {
			if( i == NUM_UBICACIONES - 1) {
				datosUbicaciones += "(\'" + pueblos.get(rand.nextInt(pueblos.size())) + "\',\'" 
						+ generarDetalleUbicacion() + "\',"
						+ idDistritos.get(rand.nextInt(idDistritos.size())) + ");";
			}
			else{ 
				datosUbicaciones += "(\'" + pueblos.get(rand.nextInt(pueblos.size())) + "\',\'" 
						+ generarDetalleUbicacion() + "\',"
						+ idDistritos.get(rand.nextInt(idDistritos.size())) + "),\n";
				}
		}
//		insertData("Ubicacion", "NombrePueblo, DetalleUbicacion, IdDistrito", datosUbicaciones, c);		
//--------------------------------------------------------------------------------------------//		
		// Carga de datos para personas
		List<String> cedulas = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\nombre_personas.txt");
		List<String> nombres = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\nombre_personas.txt");
		List<String> apellidos = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\nombre_personas.txt");
		List<String> telefono = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\nombre_personas.txt");
		List<String> email = readList("C:\\Users\\Pc\\Desktop\\Progra 1\\data\\nombre_personas.txt");
	

	}
}