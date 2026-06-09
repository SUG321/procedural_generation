extends Control

@export var loc_Card_Scene: PackedScene

@onready var grid = $GridContainer
@onready var button = $generator

func _ready() -> void:
	button.World.connect(_on_mundo_generado)
	
func _on_mundo_generado(Generated: Dictionary) -> void:
	for child in grid.get_children():
		child.queue_free()
	
	for loc in Generated:
		var items = Generated[loc]
		var ImgPath = "res://assets/locations/location_" + loc + ".png"
		
		var newCard = loc_Card_Scene.instantiate()
		grid.add_child(newCard)
		
		newCard.setup_card(ImgPath, items)
