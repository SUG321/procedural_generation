extends Node3D

# EXPORTS
@export var human: Human
@export var mouseController: MouseController
@export var actionsMenu: ActionsMenu

# ASTARGRID
var astarGrid :AStarGrid2D

# VARIABLES
var solidStructures :Array[Vector2i]

func _ready() -> void:
	mouseController.on_ground_clicked.connect(_process_movement) # CLIC EN EL SUELO
	actionsMenu.on_navigate_requested.connect(_process_movement) # CLIC EN EL BOTON "IR AQUI" DEL MENU DE ACCIONES

# FUNCIONES DE ASTARGRID
func Initialize_Navigation(map: Dictionary , width: int, height: int) -> void:
	var numberOfSolids = 0 # DEPURACION
	
	astarGrid = AStarGrid2D.new()
	
	astarGrid.region = Rect2i(0, 0, width, height)
	astarGrid.cell_size = Vector2(1, 1)
	
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	
	for cell in map:
		var location = map[cell]["structure"]
		
		if location == "building" or  location == "house" or location == "house_boarded" or location == "bunker":
			astarGrid.set_point_solid(cell, true)
			solidStructures.append(cell)
			numberOfSolids += 1
	
	human.solidStructures = solidStructures
	
	# POR SI EL JUGADOR SE GENERA EN UN OBJETO SOLIDO
	var securePositionFound = false
	
	for x in range(width):
		for y in range(height):
			var actualCell = Vector2i(x, y)
			
			if not astarGrid.is_point_solid(actualCell):
				human.global_position = Vector3(
					actualCell.x * Config.cellSize,
					human.global_position.y,
					actualCell.y * Config.cellSize
				)
				securePositionFound = true
				break
				
		if securePositionFound:
			break
	
	# DEPURACION ---------------------------------------------
	if Config.depuration >= 1: 
		var total_celdas_grid = width * height
		print("\n[map.gd/Initialize_Navigation]: --- REPORTE DE ASTARGRID ---")
		print("- Dimensiones de la cuadrícula: ", width, "x", height)
		print("- Celdas totales de navegación: ", total_celdas_grid)
		print("- Objetos sólidos (bloqueos) registrados: ", numberOfSolids)
		print("- Celdas libres para caminar: ", (total_celdas_grid - numberOfSolids))
		print("--------------------------------------------------")
	# FIN DEPURACION -----------------------------------------

func Get_Route(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if astarGrid.is_point_solid(end):
		Utilities.Print_Message("Estructura detectada. Caminando...")
		end = Get_Free_Adyacent_Cell(end, start)
		
		if astarGrid.is_point_solid(end):
			Utilities.Print_Message("La estructura esta rodeada imposible llegar...")
			return []
	
	var route = astarGrid.get_id_path(start, end)
	if route.size() == 0:
		Utilities.Print_Message("Imposible de llegar...")
	
	return route

func Get_Free_Adyacent_Cell(targetCell: Vector2i, actualPlayerCell: Vector2i) -> Vector2i:
	var directions = [
		Vector2i(0, 1),		# ABAJO
		Vector2i(0, -1),	# ARRIBA
		Vector2i(1, 0),		# DERECHA
		Vector2i(-1, 0)		# IZQUIERDA
		#Vector2i(1, 1),	# ESQUINA INFERIOR DERECHA
		#Vector2i(1, -1),	# ESQUINA SUPERIOR DERECHA
		#Vector2i(-1, 1),	# ESQUINA INFERIOR IZQUIERDA
		#Vector2i(-1, -1)	# ESQUINA SUPERIOR IZQUIERDA
	]
	
	var bestCell = targetCell
	var minimumDistance = INF
	
	var foundCell = false
	for direction in directions:
		var nearbyCell = targetCell + direction
		
		if astarGrid.is_in_boundsv(nearbyCell) and not astarGrid.is_point_solid(nearbyCell):
			var distance = actualPlayerCell.distance_to(nearbyCell)
			
			if distance < minimumDistance:
				minimumDistance = distance
				bestCell = nearbyCell
				foundCell = true
				
	if foundCell:
		return bestCell
	else:
		return targetCell

# FUNCIONES DE SEÑALES

func _process_movement(targetPosition3D: Vector3) -> void:
	var destinyCell = Vector2i(
		round(targetPosition3D.x / Config.cellSize),
		round(targetPosition3D.z / Config.cellSize)
	)

	if astarGrid != null: # SI NO ESTA VACIA
		if not astarGrid.is_in_boundsv(destinyCell): # EN CASO DE QUE SALGA DEL MAPA
			Utilities.Print_Message("El lugar al que intentas ir está fuera de los límites del mapa.")
			return

		var cellStart = Vector2i(
			round(human.global_position.x / Config.cellSize),
			round(human.global_position.z / Config.cellSize)
		)
		
		var route = Get_Route(cellStart, destinyCell)
		human.Follow_Route(route)
		
		# DEPURACION ---------------------------------------------
		if Config.depuration >= 2:
			print("\n[map.gd/_unhandled_input]: --- NUEVO CLIC DETECTADO ---")
			print("- Coordenada Real 3D  : X: ", snapped(targetPosition3D.x, 0.1), ", Z: ", snapped(targetPosition3D.z, 0.1))
			print("- Traducido a Celda   : ", destinyCell)
			print("- Inicio del Personaje: ", cellStart)
			
			if route.is_empty():
				print("- ESTADO DE RUTA: AStarGrid devolvió [] (Destino bloqueado o inalcanzable)")
			else:
				print("- ESTADO DE RUTA: Ruta trazada exitosamente.")
			print("------------------------------------------------------------------")
		# FIN DEPURACION -----------------------------------------
