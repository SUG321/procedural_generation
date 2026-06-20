# generator_menu.gd
extends PanelContainer

# MODULOS EXPORT
	# GENERATOR PANEL
@export var map3D: Node3D
@export var button: Button # SEED BUTTON
@export var seedText: TextEdit # SEED TEXTBOX
@export var widthRange: Range # RANGE ALTO
@export var depthRange: Range # RANGE ANCHO

	# MESSAGES PANEL
@export var messagesTextBox: TextEdit # MESSAGES TEXTBOX
@export var human: Human # MESSAGES HUMAN (PATH ENDED SIGNAL)

# VARIABLES
var defaultMessage: String = "..."

# FUNCIONES INTEGRADAS
func _ready() -> void:
	button.pressed.connect(_on_button_pressed) # CONECCION A SEÑAL: BOTON PRESIONADO
	Utilities.connect("signalMessage", _on_message_emit) # CONECCION A SEÑAL: MENSAJE EMITIDO POR CLASE UTILITIES

# SEÑALES
func _on_button_pressed() -> void: # FUNCION: BOTON PRESIONADO
	
	var depth: int = int(widthRange.value)
	var width: int = int(depthRange.value)
	
	var world: Generator = Generator.new()
	world.mapWidth = depth
	world.mapDepth = width
	world.Generate(seedText.text, map3D)
	
	map3D.Initialize_Navigation(world.map, depth, width)

func _on_message_emit(message: String) -> void:
	messagesTextBox.text = message
	await human.on_path_ended
	messagesTextBox.text = defaultMessage
