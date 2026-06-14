extends Node3D

# MODULOS ONREADY
@onready var human :Human = $"../Human"

# ASTARGRID
var astarGrid :AStarGrid2D

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
		
		if location == "building" or location == "house" or location == "house_boarded" or location == "bunker":
			astarGrid.set_point_solid(cell, true)
			numberOfSolids += 1
			
	if Config.depuration >= 1: print("[map.gd/Initialize_Navigation]: OBJETOS SOLIDOS GENERADOS. (", numberOfSolids ," estructuras)")
	human.global_position = Vector3(0, 0, 0)

func Get_Route(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if astarGrid.is_point_solid(end):
		print("[GAMEPLAY]: No se puede llegar a ese lugar...")
		return []
	
	var route = astarGrid.get_id_path(start, end)
	return route
