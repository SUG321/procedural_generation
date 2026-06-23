# human.gd
class_name Human extends Node3D

# EXPORTS
@export var humanName: String = "Pablito"
@export var inventoryData: Inventory

# SIGNALS
signal on_path_ended()

# VARIABLES
var actualRoute :Array[Vector2i] = []
var movementVelocity :float = 6.0
var solidStructures: Array[Vector2i]
var pathEneded: bool = false

func _ready() -> void:
	if inventoryData == null:
		inventoryData = Inventory.new()
		inventoryData.canTransferItems = true

func Follow_Route(newRoute :Array[Vector2i]) -> void:
	if newRoute.size() != 0:
		Utilities.Print_Message(humanName + ": En camino...")
	actualRoute = newRoute
	
	# DEPURACION ---------------------------------------------
	if Config.depuration >= 2:
		print("\n[Human.gd/Follow_Route]: --- ORDEN DE MOVIMIENTO RECIBIDA ---")
		print("- Pasos a recorrer : ", actualRoute.size())
		print("- Ruta a seguir    : ", actualRoute)
		print("--------------------------------------------------------------")
	# FIN DEPURACION -----------------------------------------

func _physics_process(delta :float) -> void:
	if actualRoute.size() > 0:
		var nextCell: Vector2i = actualRoute[0]
		var destinationPosition: Vector3 = Vector3(
			nextCell.x * Config.cellSize,
			global_position.y,
			nextCell.y * Config.cellSize
		)
	
		global_position = global_position.move_toward(destinationPosition, movementVelocity * delta)
		
		if global_position.distance_to(destinationPosition) < 0.05:
			actualRoute.pop_front()
			if actualRoute == []:
				on_path_ended.emit()
	else:
		# [DEV] PROXIMA LOGICA A TRABAJAR UNA VEZ SE ACABE LA RUTA
		pass
