extends Control

# MODULOS ONREADY
	# GENERATOR PANEL
@onready var map3D: Node3D = $"../../Map"
@onready var button: Button = $Panel/MarginContainer/VBoxContainer/Seed/Button
@onready var seedText: TextEdit = $Panel/MarginContainer/VBoxContainer/Seed/Seed
@onready var widthRange: Range = $Panel/MarginContainer/VBoxContainer/Coords/Alto
@onready var depthRange: Range = $Panel/MarginContainer/VBoxContainer/Coords/Ancho

	# MESSAGES PANEL
@onready var messagesTextBox: TextEdit = $MessagesPanel/MarginContainer/MessagesTextBox
@onready var messageTimer: Timer = $MessageTimer

# VARIABLES
var defaultMessage = "..."

# FUNCIONES INTEGRADAS
func _ready() -> void:
	button.pressed.connect(_on_button_pressed) # CONECCION A SEÑAL: BOTON PRESIONADO
	Utilities.connect("signalMessage", _on_message_emit) # CONECCION A SEÑAL: MENSAJE EMITIDO POR CLASE UTILITIES
	messageTimer.timeout.connect(_on_message_timer_timeout) # CONECCION A SEÑAL: TIMER AGOTADO

# SEÑALES
func _on_button_pressed() -> void: # FUNCION: BOTON PRESIONADO
	
	var depth :int = int(widthRange.value)
	var width :int = int(depthRange.value)
	
	var world =  Generator.new()
	world.mapWidth = depth
	world.mapDepth = width
	world.Generate(seedText.text, map3D)
	
	map3D.Initialize_Navigation(world.map, depth, width)

func _on_message_emit(message: String) -> void:
	messagesTextBox.text = message
	messageTimer.start(2.0)
	
func _on_message_timer_timeout() -> void:
	messagesTextBox.text = defaultMessage
