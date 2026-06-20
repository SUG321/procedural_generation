# inventory.gd
class_name InventoryUI extends PanelContainer

# EXPORTS
@export var titleLabel: Label
@export var getItemButton: Button
@export var dropItemButton: Button
@export var itemGrid: GridContainer

# VARIABLES
var currentInventory: Inventory

func loadInventory(newInventory: Inventory) -> void:
	titleLabel.text = name
	currentInventory = newInventory
	Refresh_UI()

func Refresh_UI() -> void:
	pass
