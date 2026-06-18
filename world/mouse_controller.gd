extends Camera3D
class_name MouseController

# SEÑALES
signal on_click()
signal on_ground_clicked(intersectionPoint: Vector3)
signal on_structure_clicked(structureNode: Node3D, screenPosition: Vector2)
signal on_mouse_motion(intersectionPoint: Vector3)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		Raycast_2D(event)

func Raycast_2D(event: InputEvent) -> void:
	var mousePosition = event.position
	
	var rayOrigin = project_ray_origin(mousePosition)
	var rayDirection = project_ray_normal(mousePosition)
	
	if event is InputEventMouseMotion:
		var plane = Plane(Vector3.UP, 0.0)
		var intersectionPoint = plane.intersects_ray(rayOrigin, rayDirection)
		
		if intersectionPoint != null:
			on_mouse_motion.emit(intersectionPoint)
	
	# RAYCAST 3D ------------------------------
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		on_click.emit()
		
		if Raycast_3D(rayOrigin, rayDirection):
			return
		
		var plane = Plane(Vector3.UP, 0.0)
		var intersectionPoint = plane.intersects_ray(rayOrigin, rayDirection)
		
		if intersectionPoint != null:
			on_ground_clicked.emit(intersectionPoint)
	# FINAL RAYCAST 3D -------------------------

func Raycast_3D(rayOrigin: Vector3, rayDirection: Vector3) -> bool:
	var spaceState = get_world_3d().direct_space_state
	var rayEnd = rayOrigin + rayDirection * 2000.0
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	query.collide_with_areas = true
	
	var result = spaceState.intersect_ray(query)
	
	if result and result.collider.is_in_group("structures"):
		var collidedObject = result.collider
		var position2D = unproject_position(collidedObject.global_position)
		
		on_structure_clicked.emit(collidedObject, position2D)
		return true
	return false
