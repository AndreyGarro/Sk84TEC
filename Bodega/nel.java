
		
//-------------------------------------------------------------------------------------------------------------------------------------------//
		//Cargar Paises
		String datosPaises = "";
		datosPaises += " ('Costa Rica');";
		
//		insertData("Pais", "Nombre", datosPaises, c );

//--------------------------------------------------------------------------------------------//
		//Cargar Provincias
		List<String> provincias = readList("..\\data\\provincias.txt");
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
		insertData("Provincia", "Nombre, IdPais", datosProvincias, c);
//--------------------------------------------------------------------------------------------//
		//Cargar Cantones
		List<String> cantonesSJ = readList("..\\data\\cantones_san_jose.txt");
		List<Integer> idProvinciaSJ =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'San José' ", "IdProvincia");
		
		List<String> cantonesH = readList("..\\data\\cantones_heredia.txt");
		List<Integer> idProvinciaH =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Heredia' ", "IdProvincia");
		
		List<String> cantonesA = readList("..\\data\\cantones_alajuela.txt");
		List<Integer> idProvinciaA =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Alajuela' ", "IdProvincia");
		
		List<String> cantonesC = readList("..\\data\\cantones_cartago.txt");
		List<Integer> idProvinciaC =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Cartago' ", "IdProvincia");
		
		List<String> cantonesP = readList("..\\data\\cantones_puntarenas.txt");
		List<Integer> idProvinciaP =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Puntarenas' ", "IdProvincia");
		
		List<String> cantonesL = readList("..\\data\\cantones_limon.txt");
		List<Integer> idProvinciaL =  consultInteger(c, "SELECT IdProvincia FROM Provincia P WHERE P.Nombre = 'Limón' ", "IdProvincia");
		
		List<String> cantonesG = readList("..\\data\\cantones_guanacaste.txt");
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
		insertData("Canton", "Nombre, IdProvincia", datosCantones, c);
//--------------------------------------------------------------------------------------------//
		//Carga distritos
		List<String> distritosSJ = readList("..\\data\\distritos_san_jose.txt");
		List<Integer> idCantonesSJ =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P"
				+ " ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'San José'", "IdCanton");
		
		List<String> distritosA = readList("..\\data\\distritos_alajuela.txt");
		List<Integer> idCantonesA =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P "
				+ "ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Alajuela'", "IdCanton");
		
		List<String> distritosC = readList("..\\data\\distritos_cartago.txt");
		List<Integer> idCantonesC =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P "
				+ "ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Cartago'", "IdCanton");
		
		List<String> distritosG = readList("..\\data\\distritos_guanacaste.txt");
		List<Integer> idCantonesG =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P "
				+ "ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Guanacaste'", "IdCanton");
		
		List<String> distritosH = readList("..\\data\\distritos_heredia.txt");
		List<Integer> idCantonesH =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P "
				+ "ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Heredia'", "IdCanton");
		
		List<String> distritosL = readList("..\\data\\distritos_limon.txt");
		List<Integer> idCantonesL =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P "
				+ "ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Limón'", "IdCanton");
		
		List<String> distritosP = readList("..\\data\\distritos_puntarenas.txt");
		List<Integer> idCantonesP =  consultInteger(c, "SELECT IdCanton FROM Canton C INNER JOIN Provincia P "
				+ "ON C.IdProvincia = P.IdProvincia WHERE P.Nombre = 'Puntarenas'", "IdCanton");

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
		List<String> pueblos = readList("..\\data\\pueblos.txt");
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
		List<String> cedulas = readList("..\\data\\nombre_personas.txt");
		List<String> nombres = readList("..\\data\\nombre_personas.txt");
		List<String> apellidos = readList("..\\data\\nombre_personas.txt");
		List<String> telefono = readList("..\\data\\nombre_personas.txt");
		List<String> email = readList("..\\data\\nombre_personas.txt");