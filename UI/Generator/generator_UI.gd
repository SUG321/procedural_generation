extends Control

# MODULOS ONREADY
@onready var map3D = $"../../Map"
@onready var button = $Panel/MarginContainer/VBoxContainer/Seed/Button
@onready var seedText = $Panel/MarginContainer/VBoxContainer/Seed/Seed
@onready var widthRange = $Panel/MarginContainer/VBoxContainer/Coords/Alto
@onready var depthRange = $Panel/MarginContainer/VBoxContainer/Coords/Ancho

# VARIABLES
@onready var width :int = widthRange.value
@onready var depth :int = depthRange.value

# FUNCIONES INTEGRADAS
func _ready() -> void:
	button.pressed.connect(_on_button_pressed) # CONECCION A SEÑAL: BOTON PRESIONADO

# SEÑALES
func _on_button_pressed() -> void: # FUNCION: BOTON PRESIONADO
	for child in map3D.get_children():
		child.queue_free()
	
	var world =  Generator.new()
	world.mapWidth = width
	world.mapDepth = depth
	world.Generate(seedText.text, map3D)
	
	map3D.Initialize_Navigation(world.map, width, depth)
