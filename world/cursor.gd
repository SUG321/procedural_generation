extends MeshInstance3D

# EXPORTS
@export var mouseController: MouseController
@export var beatVelocity: float = 0.5

# VARIABLES
var albedoValue: float = 0.5
var direction: float = -1.0

func _ready() -> void:
	if mesh is PlaneMesh:
		mesh.size = Vector2(Config.cellSize, Config.cellSize)
	
	show()
	
	if mouseController:
		mouseController.on_mouse_motion.connect(_on_mouse_motion)

func _on_mouse_motion(mousePosition: Vector3) -> void:
	var cellX = round(mousePosition.x / Config.cellSize)
	var cellZ = round(mousePosition.z / Config.cellSize)
	
	var cellCenterX = cellX * Config.cellSize
	var cellCenterZ = cellZ * Config.cellSize
	
	global_position = Vector3 (cellCenterX, 0, cellCenterZ)

func _process(delta: float) -> void:
	albedoValue += direction * beatVelocity * delta
	
	if albedoValue <= 0.2: # DE ABAJO A ARRIBA
		albedoValue = 0.2
		direction = 1.0
	elif albedoValue >= 0.5: # DE ARRIBA A ABAJO
		albedoValue = 0.5
		direction = -1.0
	
	if material_override != null:
		material_override.albedo_color.a = albedoValue
	elif get_active_material(0) != null:
		get_active_material(0).albedo_color.a = albedoValue
