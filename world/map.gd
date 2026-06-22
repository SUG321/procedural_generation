# map.gd
class_name MapLogic extends Node3D

# EXPORTS
@export var human: Human

# ASTARGRID
var astarGrid :AStarGrid2D

# VARIABLES
var solidStructures :Array[Vector2i]

# FUNCIONES DE ASTARGRID
func Initialize_Navigation(map: Dictionary[Vector2, MapCell], width: int, height: int) -> void:
	var numberOfSolids: int = 0 # DEPURACION
	
	astarGrid = AStarGrid2D.new()
	
	astarGrid.region = Rect2i(0, 0, width, height)
	astarGrid.cell_size = Vector2(1, 1)
	
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	
	for cell in map:
		var structure: StructureData = map[cell].structure
		
		if structure.solid == true:
			astarGrid.set_point_solid(cell, true)
			solidStructures.append(cell)
			numberOfSolids += 1
	
	human.solidStructures = solidStructures
	
	# POR SI EL JUGADOR SE GENERA EN UN OBJETO SOLIDO
	var securePositionFound: bool = false
	
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
		var total_celdas_grid: float = width * height
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
	
	var route: Array[Vector2i] = astarGrid.get_id_path(start, end)
	if route.size() == 0:
		Utilities.Print_Message("Imposible de llegar...")
	
	return route

func Get_Free_Adyacent_Cell(targetCell: Vector2i, actualPlayerCell: Vector2i) -> Vector2i:
	var directions: Array[Vector2i] = [
		Vector2i(0, 1),		# ABAJO
		Vector2i(0, -1),	# ARRIBA
		Vector2i(1, 0),		# DERECHA
		Vector2i(-1, 0)		# IZQUIERDA
		#Vector2i(1, 1),	# ESQUINA INFERIOR DERECHA
		#Vector2i(1, -1),	# ESQUINA SUPERIOR DERECHA
		#Vector2i(-1, 1),	# ESQUINA INFERIOR IZQUIERDA
		#Vector2i(-1, -1)	# ESQUINA SUPERIOR IZQUIERDA
	]
	
	var bestCell: Vector2i = targetCell
	var minimumDistance: float = INF
	
	var foundCell: bool = false
	for direction in directions:
		var nearbyCell: Vector2i = targetCell + direction
		
		if astarGrid.is_in_boundsv(nearbyCell) and not astarGrid.is_point_solid(nearbyCell):
			var distance: float = actualPlayerCell.distance_to(nearbyCell)
			
			if distance < minimumDistance:
				minimumDistance = distance
				bestCell = nearbyCell
				foundCell = true
				
	if foundCell:
		return bestCell
	else:
		return targetCell

# FUNCIONES DE SEÑALES

func Request_Movement(targetPosition3D: Vector3) -> bool:
	var destinyCell: Vector2i = Vector2i(
		round(targetPosition3D.x / Config.cellSize),
		round(targetPosition3D.z / Config.cellSize)
	)
	
	if astarGrid == null:
		return false
	
	if not astarGrid.is_in_boundsv(destinyCell): # EN CASO DE QUE SALGA DEL MAPA
		Utilities.Print_Message("El lugar al que intentas ir está fuera de los límites del mapa.")
		return false

	var cellStart: Vector2i = Vector2i(
		round(human.global_position.x / Config.cellSize),
		round(human.global_position.z / Config.cellSize)
	)
	
	var route: Array[Vector2i] = Get_Route(cellStart, destinyCell)
	
	if route.size() == 0:
		return false
	
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
	
	return true
