import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ScriptSucursal {
	
    private static final String CONTROLADOR = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/sucursal";
    private static final String USUARIO = "root";
    private static final String CLAVE = "12345678";

    public static Connection conectarMySql() {
        Connection conexion = null;
        
        try {
            Class.forName(CONTROLADOR);
            conexion = DriverManager.getConnection(URL, USUARIO, CLAVE);
            System.out.println("Conexión OK");

        } catch (ClassNotFoundException e) {
            System.out.println("Error al cargar el controlador");
            e.printStackTrace();

        } catch (SQLException e) {
            System.out.println("Error en la conexión");
            e.printStackTrace();
        }
        
        return conexion;
    }
    
    
	public static Connection conectarPostgres(String DBName, String password) {
		Connection connection = null;
		try {
			try {
				Class.forName("org.postgresql.Driver");
			} catch (ClassNotFoundException ex) {
				System.out.println("Error al registrar el driver de PostgreSQL: " + ex);
			}
			connection = DriverManager.getConnection("jdbc:postgresql://172.26.42.130:5432/" + DBName, "postgres",
					password);

			boolean valid = connection.isValid(50000);
			System.out.println(valid ? "Valid connection" : "Fail connection");
		} catch (java.sql.SQLException sqle) {
			System.out.println("Error: " + sqle);
		}
		return connection;
	}
	
	public static List<String> consultString(Connection con, String consult, String dato) {
		List<String> result = new ArrayList<String>();
		try (Statement stmt = con.createStatement(); 
				ResultSet rs = stmt.executeQuery(consult)) {
			while (rs.next()) {
				result.add(rs.getString(dato));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return result;
	}
	
	public static void updateData(String tabla, String atributo, String dato, Connection c, String atributo2, String valor) {
		try {
			Statement state = c.createStatement();
			state.executeUpdate("UPDATE" + tabla + " SET " + atributo + " = " + dato + " WHERE " + atributo2 +" = " + valor+";");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static void insertData(String tabla, String atributos, String datos, Connection c) {
		try {
			Statement state = c.createStatement();
			state.executeUpdate("INSERT INTO " + tabla + " (" + atributos + ")" + " VALUES " + datos);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void insertIgnore(String tabla, String atributos, String datos, Connection c) {
		try {
			Statement state = c.createStatement();
			state.executeUpdate("INSERT INTO " + tabla + " (" + atributos + ")" + " VALUES " + datos);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	public static List<List<String>> consultarCliente(Connection con, String consult) {
		List<List<String>> clientes = new ArrayList<List<String>>();
		List<String> cliente = new ArrayList<String>();
		try (Statement stmt = con.createStatement(); 
				ResultSet rs = stmt.executeQuery(consult)) {
			
			int cont = 0;
			while (rs.next()) {
				for(int i = 1;  i < 28; i++ )
				{
					cliente.add(rs.getString(i));
				}
				clientes.add(new ArrayList<String>(cliente));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return clientes;
	}
	
	
	
	public static void main(String[] args) {
		Connection mySQL = conectarMySql();
		Connection postgresSQL = conectarPostgres("ProyectoUno", "12345678");
		List<List<String>> clientes = consultarCliente(postgresSQL, "SELECT * FROM agregarCliente()");
		for(int i =0; i < 1000; i++) {
			List<String> cliente = clientes.get(i);
			if(consultString(mySQL,"SELECT IdCliente FROM Cliente C WHERE C.IdCliente = "+ cliente.get(0) +";" , "IdCliente").size() == 0) {
				
			}else {
				updateData("Cliente", "PuntosAcomulados", cliente.get(1), mySQL, "IdCliente", cliente.get(0));
			}
			
		}
	
	}
}