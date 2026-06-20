# Structure.gd
class_name Structure extends Area3D

var structureName: String = ""
var inventoryData: Inventory

func _ready() -> void:
	if inventoryData == null:
		inventoryData = Inventory.new()
		inventoryData.canGetItems = false # ESTRUCTURA NO GUARDA

func Set_Loot(lootArray: Array) -> void:
	if inventoryData == null:
		inventoryData = Inventory.new()
		inventoryData.canGetItems = false
	
	inventoryData.items = lootArray
