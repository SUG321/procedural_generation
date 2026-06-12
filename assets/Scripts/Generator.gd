class_name Generator
extends RefCounted

# MAQUINAS
var rng = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()

# Variables
var depuration = 1
var map_width = 10 # X
var map_depth = 10 # Z
var map = {}
var cell_size = 4

# DICCIONARIOS
var locations = ObjDictionary.Structures # Estructuras
var objects = ObjDictionary.Items # Objetos
var limits = ObjDictionary.Dificults # Limites de Peso
var locationsTex = ObjDictionary.StructuresTexts # Texturas


func Generate(Seed: String, world: Node3D) -> void:
	var _Seed = Seed.hash()
	rng.seed = _Seed
	noise.seed = _Seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.08
	
	Generate_Map(map_depth, map_width)
	Generate3D(world)


func Generate_World(presupuesto) -> Dictionary:
	var _Final = {};
	var Locaciones_Temp = Generate_Item(presupuesto, locations);
	# DEPURACION ---------------------------------------------
	if depuration >= 1: print("\nGENERACION LOCACIONES TERMINADA -----------------");
	# FDEP --------------------------------------------------- 
	
	for loc in Locaciones_Temp:
		var Objetos_Temp = Generate_Item(loc["loot"], objects);
		# DEPURACION ---------------------------------------------
		if depuration >= 1: print("GENERACION LOOT TERMINADA -----------------");
		# FDEP --------------------------------------------------- 
		
		_Final[loc["nombre"]] = [];
		
		for obj in Objetos_Temp:
			_Final[loc["nombre"]].append(obj["nombre"]);
	
	return _Final;


func Generate_Map(ancho: int, alto: int):
	# DEPURACION ---------------------------------------------
	if depuration>= 2: print("\n...INIT GEN MAPA")
	# FDEP --------------------------------------------------- 
	map.clear()
	var unPositions = {}
	
	for y in range(alto):
		var fila = ""
		for x in range(ancho):
			var valor = noise.get_noise_2d(x, y)
			var prespCelda = 0
			var icono = ""
			
			if valor > 0.3:
				prespCelda = 80
				# DEPURACION ---------------------------------------------
				if depuration >= 2: icono = "██"
			elif valor > 0.0:
				prespCelda = 30
				# DEPURACION ---------------------------------------------
				if depuration >= 2: icono += "▒▒"
			else:
				prespCelda = 10
				# DEPURACION ---------------------------------------------
				if depuration >= 2: icono += ".."
			
			fila += icono
			
			var genLocs = Generate_Item(prespCelda, locations)
			if genLocs.size() > 0:
				var prinLoc = genLocs[0]
				var locName = prinLoc["nombre"]
				
				if locName != "Nada":
					var minDistance = 0
					
					if locName == "well":
						minDistance = 20
					elif locName == "bunker":
						minDistance = 30
					elif locName == "camp":
						minDistance = 10
					elif locName == "house_boarded":
						minDistance = 20
					
					var vClose = false
					if minDistance > 0:
						if unPositions.has(locName):
							for pos in unPositions[locName]:
								if pos.distance_to(Vector2(x, y)) < minDistance:
									vClose = true
									break
					
					if vClose:
						locName = "Nada"
					else:
						if minDistance > 0:
							if not unPositions.has(locName):
								unPositions[locName] = []
							unPositions[locName].append(Vector2(x, y))
				
				if locName != "Nada":
					var genObjs = Generate_Item(prinLoc["loot"], objects)
					var listLoot = []
					for obj in genObjs:
						listLoot.append(obj["nombre"])
					map[Vector2(x, y)] = {
						"estructura": prinLoc["nombre"],
						"loot": listLoot
					}
		# DEPURACION ---------------------------------------------
		if depuration >= 2: print(fila)
		# FDEP --------------------------------------------------- 
	
	# DEPURACION ---------------------------------------------
	if depuration >= 1: print("\nGENERACION MAPA TERMINADA -----------------");
	if depuration >= 2: print("\nEl mundo tiene ", map.size(), " locations con loot")
	
	if depuration >= 3:
		var test_coord = Vector2(10, 10)
		if map.has(test_coord):
			print("\nEn la coordenada ", test_coord, " hay: ", map[test_coord]["estructura"])
			print("Contiene este loot: ", map[test_coord]["loot"])
		else:
			print("\nLa coordenada ", test_coord, " es un terreno vacío.")
	# FDEP --------------------------------------------------- 


func Generate_Item(presupuesto: int, lista: Array) -> Array:
	var pesoTotal = 0;
	var _Seleccion = [];
	
	for i in range(lista.size()):
		pesoTotal += lista[i]["peso"];
	
	while presupuesto > 0:
		var tirada = rng.randi_range(1, pesoTotal); 
		var locacionTemporal = {};
		
		for loc in lista:
			tirada -= loc["peso"];
			if tirada <= 0:
				locacionTemporal = loc;	
				break;
				
		
		if locacionTemporal["peso"] <= presupuesto:
			var loc = locacionTemporal;
			
			if loc["nombre"] == "Nada":
				presupuesto = 0;
			
			presupuesto -= loc["peso"];
			_Seleccion.append(loc);
		else:
			break;
	return _Seleccion;


func Generate3D(world: Node3D) -> void:
	for child in world.get_children():
		if child is Sprite3D:
			child.queue_free()
	
	# DEPURACION ---------------------------------------------
	if depuration >= 2: print("\n...LEVANTANDO EL MUNDO 3D")
	# FDEP --------------------------------------------------- 
	
	for coordenada2D in map.keys():
		var locDatos = map[coordenada2D]
		var locNombre = locDatos["estructura"]
		var newSprite3D = Sprite3D.new()
		
		if locationsTex.has(locNombre):
			newSprite3D.texture = locationsTex[locNombre]
		
		# CAMBIO DE COORDENADAS 2D a 3D
		# X 2D = X 3D.
		# Y 2D = Z 3D.
		var posicion_3d = Vector3(
			coordenada2D.x * cell_size, 
			0, # Y 3D = 0 (Suelo)
			coordenada2D.y * cell_size
		)
		
		newSprite3D.position = posicion_3d
		newSprite3D.billboard = 1
		
		# Si la imagen mide 128px de alto y el pixel_size es 0.01 se sube a la mitad
		newSprite3D.position.y += (newSprite3D.texture.get_height() * newSprite3D.pixel_size) / 2.0
		
		
		world.add_child(newSprite3D)
		
	# DEPURACION ---------------------------------------------
	if depuration >= 1: print("GENERACION DE MAPA 3D TERMINADA (" , map.size(), " estructuras)", " ----------------- ")
	# FDEP --------------------------------------------------- 
