# mouse_controller.gd
class_name MouseController extends Camera3D

# SEÑALES
signal on_click()
signal on_mouse_motion(intersectionPoint: Vector3)
signal on_structure_clicked(structureNode: Node3D, screenPosition: Vector2)

# EXPORTS
@export var mapLogic: MapLogic

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		Raycast_2D(event)

func Raycast_2D(event: InputEvent) -> void:
	var mousePosition: Vector2 = event.position
	
	var rayOrigin: Vector3 = project_ray_origin(mousePosition)
	var rayDirection: Vector3 = project_ray_normal(mousePosition)
	
	if event is InputEventMouseMotion:
		var plane: Plane = Plane(Vector3.UP, 0.0)
		var intersectionPoint: Vector3 = plane.intersects_ray(rayOrigin, rayDirection)
		
		if intersectionPoint != null:
			on_mouse_motion.emit(intersectionPoint)
	
	# RAYCAST 3D ------------------------------
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		on_click.emit()
		
		if Raycast_3D(rayOrigin, rayDirection):
			return
		
		var plane: Plane = Plane(Vector3.UP, 0.0)
		var intersectionPoint: Vector3 = plane.intersects_ray(rayOrigin, rayDirection)
		
		if intersectionPoint != null:
			mapLogic.Request_Movement(intersectionPoint)
	# FINAL RAYCAST 3D -------------------------

func Raycast_3D(rayOrigin: Vector3, rayDirection: Vector3) -> bool:
	var spaceState: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var rayEnd: Vector3 = rayOrigin + rayDirection * 2000.0
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	query.collide_with_areas = true
	
	var result: Dictionary = spaceState.intersect_ray(query)
	
	if result and result.collider.is_in_group("structures"):
		var collidedObject: Structure = result.collider
		var position2D: Vector2 = unproject_position(collidedObject.global_position)
		
		on_structure_clicked.emit(collidedObject, position2D)
		return true
	return false
