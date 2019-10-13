
/**
 * Código obtenido en: https://www.mkyong.com/java/how-to-read-and-parse-csv-file-in-java/
 * Author: mkyong
 */

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class CSVUtils {

	private static final char DEFAULT_SEPARATOR = ',';
	private static final char DEFAULT_QUOTE = '\'';

	public static List<String> parseLine(String cvsLine) {
		return parseLine(cvsLine, DEFAULT_SEPARATOR, DEFAULT_QUOTE);
	}

	public static List<String> parseLine(String cvsLine, char separators) {
		return parseLine(cvsLine, separators, DEFAULT_QUOTE);
	}

	public static List<String> parseLine(String cvsLine, char separators, char customQuote) {

		List<String> result = new ArrayList<>();

		if (cvsLine == null && cvsLine.isEmpty()) {
			return result;
		}

		if (customQuote == ' ') {
			customQuote = DEFAULT_QUOTE;
		}

		if (separators == ' ') {
			separators = DEFAULT_SEPARATOR;
		}

		StringBuffer curVal = new StringBuffer();
		boolean inQuotes = false;
		boolean startCollectChar = false;
		boolean doubleQuotesInColumn = false;

		char[] chars = cvsLine.toCharArray();

		for (char ch : chars) {

			if (inQuotes) {
				startCollectChar = true;
				if (ch == customQuote) {
					inQuotes = false;
					doubleQuotesInColumn = false;
				} else {
					if (ch == '\"') {
						if (!doubleQuotesInColumn) {
							curVal.append(ch);
							doubleQuotesInColumn = true;
						}
					} else {
						curVal.append(ch);
					}

				}
			} else {
				if (ch == customQuote) {

					inQuotes = true;
					if (chars[0] != '"' && customQuote == '\"') {
						curVal.append('"');
					}
					if (startCollectChar) {
						curVal.append('"');
					}

				} else if (ch == separators) {

					result.add(curVal.toString());

					curVal = new StringBuffer();
					startCollectChar = false;

				} else if (ch == '\r') {
					continue;
				} else if (ch == '\n') {
					break;
				} else {
					curVal.append(ch);
				}
			}

		}

		result.add(curVal.toString());

		return result;
	}

	public String getData(String table, Scanner scanner) {
		String row = "";
		List<String> line = new ArrayList<String>();
		switch (table) {
		case "Empleado":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(0) + ", '" + line.get(1) + "', '" + line.get(2) + "', " + line.get(3) + ", "
						+ line.get(4) + ", " + line.get(5) + ", " + line.get(6) + ", " + line.get(7) + "), \n";
			}
			break;
		case "Puesto":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(7) + ", '" + line.get(8) + "', " + line.get(9) + "), \n";
			}
			break;
		case "Horario":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(10) + ", " + line.get(11) + ", " + line.get(12) + ", " + line.get(13) + ", "
						+ line.get(14) + ", " + line.get(15) + ", " + line.get(16) + ", " + line.get(17) + ", '"
						+ line.get(18) + "', '" + line.get(19) + "'), \n";
			}
			break;
		case "PersonaEmp":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(20) + ", '" + line.get(21) + "', '" + line.get(22) + "', '" + line.get(23)
						+ "', '" + line.get(24) + "', '" + line.get(25) + "', '" + line.get(26) + "', " + line.get(27)
						+ "), \n";
			}
			break;
		case "UbicacionEmp":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(28) + ", '" + line.get(29) + "', '" + line.get(30) + "', " + line.get(31)
						+ "), \n";
			}
			break;
		case "DistritoEmp":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(32) + ", '" + line.get(33) + "', " + line.get(34) + "), \n";
			}
			break;
		case "CantonEmp":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(35) + ", '" + line.get(36) + "', " + line.get(37) + "), \n";
			}
			break;
		case "ProvinciaEmp":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(38) + ", '" + line.get(39) + "', " + line.get(40) + "), \n";
			}
			break;
		case "PaisEmp":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(41) + ", '" + line.get(42) + "'), \n";
			}
			break;
		case "Cliente":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(0) + ", " + line.get(1) + ", '" + line.get(2) + "', " + line.get(3) + "), \n";
			}
			break;
		case "PersonaCli":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(4) + ", '" + line.get(5) + "', '" + line.get(6) + "', '" + line.get(7) + "', '"
						+ line.get(8) + "', '" + line.get(9) + "', '" + line.get(5) + "', " + line.get(11) + "), \n";
			}
			break;
		case "UbicacionCli":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(12) + ", '" + line.get(13) + "', '" + line.get(14) + "', " + line.get(15)
						+ "), \n";
			}
			break;
		case "DistritoCli":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(16) + ", '" + line.get(17) + "', " + line.get(18) + "), \n";
			}
			break;
		case "CantonCli":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(19) + ", '" + line.get(20) + "', " + line.get(21) + "), \n";
			}
			break;
		case "ProvinciaCli":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(22) + ", '" + line.get(23) + "', " + line.get(24) + "), \n";
			}
			break;
		case "PaisCli":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(25) + ", '" + line.get(26) + "'), \n";
			}
			break;
		case "Articulo":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(0) + ", '" + line.get(1) + "', " + line.get(2) + ", " + line.get(3) + "), \n";
			}
			break;
		case "Producto":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(4) + ", '" + line.get(5) + "', '" + line.get(6) + "', " + line.get(7) + ", '"
						+ line.get(8) + "', '" + line.get(9) + "', '" + line.get(10) + "', " + line.get(11) + ", "
						+ line.get(12) + ", " + line.get(13) + "), \n";
			}
			break;
		case "Tipo":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(14) + ", '" + line.get(15) + "'), \n";
			}
			break;
		case "Marca":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(16) + ", '" + line.get(17) + "'), \n";
			}
			break;
		case "Genero":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(18) + ", '" + line.get(19) + "'), \n";
			}
			break;
		case "Categoria":
			while (scanner.hasNext()) {
				line = parseLine(scanner.nextLine());
				row += "(" + line.get(20) + ", '" + line.get(21) + "'), \n";
			}
			break;
		default:
			System.out.println();
		}
		return row.substring(0, row.length() - 3) + ";";
	}

	public static void main(String[] args) throws Exception {

		String csvFile = "ArticuloEnvio.csv";
		Scanner scanner = new Scanner(new File(csvFile));

		CSVUtils util = new CSVUtils();

		System.out.println(util.getData("Categoria", scanner));

	}
}
