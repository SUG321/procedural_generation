extends Control

@export var slot: PackedScene
@onready var imagen = $MarginContainer/Generator/PanelContainer/ImagenLocacion
@onready var cuadricula = $MarginContainer/Generator/CuadriculaItems

func setup_card(rutaTextura: String, listaItems: Array):
	imagen.texture = load(rutaTextura)
	
	for child in cuadricula.get_children():
		child.queue_free()
	
	for obj in listaItems:
		if obj != "Nada":
			var imgPath = "res://assets/items/item_" + obj + ".png"
			var newSlot = slot.instantiate()
			cuadricula.add_child(newSlot)
			
			newSlot.get_node("IconoObjeto").texture = load(imgPath)
