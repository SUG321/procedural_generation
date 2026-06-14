class_name Human
extends Node3D

# VARIABLES
var actualRoute: Array[Vector2i] = []
var movementVelocity: float = 2.0
var cellSize: float = 4.0

func Follow_Route(newRoute: Array[Vector2i]) -> void:
	if newRoute.size() > 0:
		newRoute.pop_front()
	actualRoute = newRoute

func _physics_process(delta: float) -> void:
	if actualRoute.size() > 0:
		var nextCell = actualRoute[0]
		
		var destinationPosition = Vector3(
			nextCell.x,
			global_position.y,
			nextCell.y * cellSize
		)
	
		global_position = global_position.move_toward(destinationPosition, movementVelocity * delta)
		
		if global_position.distance_to(destinationPosition) < 0.05:
			actualRoute.pop_front()
	else:
		# [DEV] PROXIMA LOGICA A TRABAJAR UNA VEZ SE ACABE LA RUTA
		pass
