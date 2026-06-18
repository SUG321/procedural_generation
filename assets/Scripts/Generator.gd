class_name Generator
extends RefCounted

# MAQUINAS
var rng :RandomNumberGenerator = RandomNumberGenerator.new()
var noise :FastNoiseLite = FastNoiseLite.new()

# ESCENAS
var locationScene :PackedScene = preload("res://assets/scenes/structure.tscn")

# Variables
var mapWidth :int = 10 # X
var mapDepth :int = 10 # Z
var map :Dictionary = {}

# DICCIONARIOS
var locationsTextures :Dictionary = ObjDictionary.StructuresTexts # Texturas
var locations :Array = ObjDictionary.Structures # Estructuras
var objects :Array = ObjDictionary.Items # Objetos
var limits :Array = ObjDictionary.Dificults # Limites de Peso

# FUNCIONES DE MAPA
func Generate(Seed: String, world: Node3D) -> void:
	var _Seed = Seed.hash()
	rng.seed = _Seed
	noise.seed = _Seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.08
	
	Generate_Heat_Map(mapDepth, mapWidth)
	Draw_Map_Frontline(mapDepth, mapWidth, world.get_node("Limits"))
	Generate_3D_World(world.get_node("Structures"))


func Generate_Heat_Map(width: int, height: int):
	# DEPURACION ---------------------------------------------
	if Config.depuration>= 2: print("\n[generator.gd/Generate_Heat_Map]: ...INIT GEN MAPA")
	# FIN DEPURACION -----------------------------------------
	map.clear()
	var uniquePositions = {}
	
	for y in range(height):
		var fila = ""
		for x in range(width):
			var value = noise.get_noise_2d(x, y)
			var cellBudget = 0
			var icon = ""
			
			if value > 0.3:
				cellBudget = 80
				# DEPURACION ---------------------------------------------
				if Config.depuration >= 2: icon = "██"
			elif value > 0.0:
				cellBudget = 30
				# DEPURACION ---------------------------------------------
				if Config.depuration >= 2: icon += "▒▒"
			else:
				cellBudget = 10
				# DEPURACION ---------------------------------------------
				if Config.depuration >= 2: icon += ".."
			
			fila += icon
			
			var generatedLocations = Generate_Entities(cellBudget, locations)
			if generatedLocations.size() > 0:
				var principalLocation = generatedLocations[0]
				var locationName = principalLocation["name"]
				
				if locationName != "Null":
					var minimumDistance = 0
					
					if locationName == "well":
						minimumDistance = 20
					elif locationName == "bunker":
						minimumDistance = 30
					elif locationName == "camp":
						minimumDistance = 10
					elif locationName == "house_boarded":
						minimumDistance = 20
					
					var veryClose = false
					if minimumDistance > 0:
						if uniquePositions.has(locationName):
							for position in uniquePositions[locationName]:
								if position.distance_to(Vector2(x, y)) < minimumDistance:
									veryClose = true
									break
					
					if veryClose:
						locationName = "Null"
					else:
						if minimumDistance > 0:
							if not uniquePositions.has(locationName):
								uniquePositions[locationName] = []
							uniquePositions[locationName].append(Vector2(x, y))
				
				if locationName != "Null":
					var generatedObjects = Generate_Entities(principalLocation["loot"], objects)
					var lootList = []
					for object in generatedObjects:
						lootList.append(object["name"])
					map[Vector2(x, y)] = {
						"structure": principalLocation["name"],
						"loot": lootList
					}
		# DEPURACION ---------------------------------------------
		if Config.depuration >= 2: print(fila)
		# FIN DEPURACION ----------------------------------------- 
	
	# DEPURACION ---------------------------------------------
	if Config.depuration >= 1: 
		var totalCells = width * height
		print("\n[generator.gd/Generate_Heat_Map]: --- REPORTE DEL MAPA DE CALOR ---")
		print("- Dimensiones: ", width, "x", height)
		print("- Total de celdas analizadas: ", totalCells)
		print("- Estructuras válidas generadas: ", map.size())
		print("--------------------------------------------------")
	# FIN DEPURACION -----------------------------------------

func Generate_Entities(budget: int, list: Array) -> Array:
	var totalWeight = 0;
	var _Selection = [];
	
	for i in range(list.size()):
		totalWeight += list[i]["weight"];
	
	while budget > 0:
		var roll = rng.randi_range(1, totalWeight); 
		var temporalLoaction = {};
		
		for location in list:
			roll -= location["weight"];
			if roll <= 0:
				temporalLoaction = location;	
				break;
				
		
		if temporalLoaction["weight"] <= budget:
			var location = temporalLoaction;
			
			if location["name"] == "Null":
				budget = 0;
			
			budget -= location["weight"];
			_Selection.append(location);
		else:
			break;
	return _Selection;

func Generate_3D_World(world: Node3D) -> void:
	Utilities.Clear_Childs(world, "structures")
	
	# DEPURACION ---------------------------------------------
	if Config.depuration >= 2: print("\n[generator.gd/Generate_3D_World]: ...GENERANDO MUNDO 3D")
	# FIN DEPURACION ----------------------------------------- 
	
	for coordinate2D in map.keys():
		var locationData = map[coordinate2D]
		var locationName = locationData["structure"]
		
		var newLocation = locationScene.instantiate()
		newLocation.structureType = locationName
		newLocation.inventory = locationData["loot"]
		newLocation.name = locationName + "_" + str(coordinate2D.x) + "_" + str(coordinate2D.y)
		
		var sprite3D = newLocation.get_node("Sprite3D")
		var collisionBox3D = newLocation.get_node("CollisionShape3D")
		
		if locationsTextures.has(locationName):
			sprite3D.texture = locationsTextures[locationName]
			
		if sprite3D.texture != null:
			var imageWidth = sprite3D.texture.get_width()
			var imageHeight = sprite3D.texture.get_height()
			
			var newPixelSize = Config.cellSize / float(imageWidth)
			sprite3D.pixel_size = newPixelSize # TAMAÑO DE LA IMAGEN
			
			var physicHeight = imageHeight * newPixelSize
			
			var boxShape = BoxShape3D.new()
			boxShape.size = Vector3(Config.cellSize, physicHeight, Config.cellSize)
			
			collisionBox3D.shape = boxShape
		
		# CAMBIO DE COORDENADAS 2D a 3D
		# X 2D = X 3D.
		# Y 2D = Z 3D.
		var position3d = Vector3(
			coordinate2D.x * Config.cellSize, 
			0, # Y 3D = 0 (Suelo)
			coordinate2D.y * Config.cellSize
		)
		
		newLocation.position = position3d
		
		# Si la imagen mide 128px de height y el pixel_size es 0.01 se sube a la mitad
		if sprite3D.texture != null:
			newLocation.position.y += (sprite3D.texture.get_height() * sprite3D.pixel_size) / 2.0
		
		newLocation.add_to_group("structures")
		world.add_child(newLocation)
		
	# DEPURACION ---------------------------------------------
	if Config.depuration >= 1: 
		print("\n[generator.gd/Generate_3D_World]: --- REPORTE DEL MUNDO 3D ---")
		print("- Nodos 3D instanciados: ", map.size())
		print("- Tamaño físico del mundo: ", mapWidth * Config.cellSize, "m x ", mapDepth * Config.cellSize, "m")
		
		print("--------------------------------------------------")
	# FIN DEPURACION -----------------------------------------

func Draw_Map_Frontline(width: int, height: int, limitsNode: Node3D) -> void:
	Utilities.Clear_Childs(limitsNode, "generatedFrontlines")
	
	var thickness: float = 0.5
	var barHeight: float = 0.2
	
	var physicLongX: float = width * Config.cellSize
	var physicLongZ: float = height * Config.cellSize
	var centerX: float = (physicLongX / 2) - (Config.cellSize / 2)
	var centerZ: float = (physicLongZ / 2) - (Config.cellSize / 2)
	
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0, 0.5) 
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	# MURO SUPERIOR NORTE
	_Create_Wall(
		Vector3(centerX, barHeight / 2.0, - Config.cellSize / 2.0),
		Vector3(physicLongX + thickness, barHeight, thickness),
		material,
		limitsNode)
	# MURO SUPERIOR SUR
	_Create_Wall(
		Vector3(centerX, barHeight / 2.0, physicLongZ - Config.cellSize / 2.0),
		Vector3(physicLongX + thickness, barHeight, thickness),
		material,
		limitsNode)
	# MURO SUPERIOR OESTE
	_Create_Wall(
		Vector3(-Config.cellSize/2.0, barHeight / 2.0, centerZ),
		Vector3(thickness, barHeight, physicLongZ +  thickness),
		material,
		limitsNode)
	# MURO SUPERIOR ESTE
	_Create_Wall(
		Vector3(physicLongX - Config.cellSize / 2.0, barHeight / 2.0, centerZ),
		Vector3(thickness, barHeight, physicLongZ +  thickness),
		material,
		limitsNode)
func _Create_Wall(position: Vector3, size: Vector3, material: StandardMaterial3D, limitsNode: Node3D) -> void:
	var wall: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	
	mesh.size = size
	wall.mesh = mesh
	wall.material_override = material
	wall.position = position
	
	wall.add_to_group("generatedFrontlines")
	limitsNode.add_child(wall)
