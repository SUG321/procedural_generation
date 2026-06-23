# actions_menu.gd
class_name ActionsMenu extends PanelContainer

# EXPORTS
@export var mouseController: MouseController # CLICKS SIGNALS
@export var human: Human # ON PATH ENDED SIGNAL
@export var goButton: Button # CLICKED SIGNAL
@export var lootButton: Button # CLICKED SIGNAL
@export var lootTimer: Timer # TIMER ENDED SIGNAL
@export var inventoriesManager: InventoriesManager # GESTOR DE INVENTARIOS
@export var mapLogic: MapLogic # GESTOR DE RUTAS

# VARIABLES
var structureTargetPosition: Vector3
var structureName: String = ""
var currentStructure: Structure = null
var isLooting: bool = false

func _ready() -> void:
	hide()
	goButton.pressed.connect(_on_go_button_pressed)
	lootButton.pressed.connect(_on_button_loot_pressed)
	if mouseController:
		mouseController.on_structure_clicked.connect(_on_structure_clicked)
		mouseController.on_click.connect(_on_click)
	inventoriesManager.New_Inventory(human.humanName, Inventory.new(), true)
	inventoriesManager.Hide_Human_Inventory()

func Show_Menu(screenPosition2D: Vector2, structure: Structure) -> void:
	currentStructure = structure
	structureTargetPosition = structure.position
	structureName = structure.structureName
	
	global_position = screenPosition2D
	show()

# FUNCIONES DE SEÑALES
func _on_go_button_pressed() -> void:
	Utilities.Print_Message("Moviendose hacia: " + structureName)
	mapLogic.Request_Movement(structureTargetPosition)
	hide()

func _on_button_loot_pressed() -> void:
	hide()
	
	if isLooting:
		Utilities.Print_Message("Ya se esta looteando una estructura. Espera a que termine.")
		return
	
	if not mapLogic.Request_Movement(structureTargetPosition):
		return
	
	isLooting = true
	await human.on_path_ended
	
	if not isLooting:
		return
	
	Utilities.Print_Message("Saqueando " + structureName + "...")
	lootTimer.start(3)
	await lootTimer.timeout
	
	if not isLooting:
		return
	
	inventoriesManager.Clear_Structure_Inventory()
	inventoriesManager.Show_Human_Inventory()
	inventoriesManager.New_Inventory(structureName, currentStructure.inventoryData)
	Utilities.Print_Message("Mostrando contenido de: " + structureName)
	isLooting = false

func _on_structure_clicked(structure: Node3D, screenPosition: Vector2) -> void:
	if structure is Structure:
		Show_Menu(screenPosition, structure)
	
func _on_click() -> void:
	hide()
	
	isLooting = false
	if not lootTimer.is_stopped():
		lootTimer.stop()
		Utilities.Print_Message("Saqueo Cancelado.")
	
	inventoriesManager.Hide_Human_Inventory()
	inventoriesManager.Clear_Structure_Inventory()
