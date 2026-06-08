extends Control

@export var slot: PackedScene
@onready var imagen = $MarginContainer/Generator/PanelContainer/ImagenLocacion
@onready var cuadricula = $MarginContainer/Generator/CuadriculaItems

signal Location(location)

func GenerateVisual(ruta_textura: String, lista: Array):
	imagen.texture = load(ruta_textura)
	
	for hijo in cuadricula.get_children():
		hijo.queue_free()
	
	for obj in lista:
		if obj != "Nada":
			var img = "res://assets/items/item_" + obj + ".png"
			
			var nuevoSlot = slot.instantiate()
			cuadricula.add_child(nuevoSlot)
			nuevoSlot.get_node("IconoObjeto").texture = load(img)

func _on_button_world(Generated: Variant) -> void:
	for loc in Generated:
		var items = Generated[loc]
		var location = "res://assets/locations/location_" + loc + ".png"
		
		Location.emit(GenerateVisual(location, items))
