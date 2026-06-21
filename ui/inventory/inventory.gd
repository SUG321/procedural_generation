# inventory.gd
class_name InventoryUI extends PanelContainer

# EXPORTS
@export var titleLabel: Label
@export var getItemButton: Button
@export var dropItemButton: Button
@export var itemGrid: GridContainer
@export var inventorySlot: PackedScene

# VARIABLES
var currentInventory: Inventory

func loadInventory(newInventory: Inventory) -> void:
	titleLabel.text = name
	currentInventory = newInventory
	
	if newInventory.canGetItems != false:
		getItemButton.show()
	if newInventory.canDropItems != false:
		dropItemButton.show()
	
	Refresh_UI()

func Refresh_UI() -> void:
	for child in itemGrid.get_children():
		if child.is_in_group("InventorySlot"):
			child.queue_free()
	
	var index: int = 0
	for item: ItemData in currentInventory.items:
		var newInventorySlot: InventorySlot = inventorySlot.instantiate()
		newInventorySlot.add_to_group("InventorySlot")
		itemGrid.add_child(newInventorySlot)
		
		newInventorySlot.Prepare_Slot(item)
		newInventorySlot.name = item.displayName + "_" + str(index)
		
		index += 1
