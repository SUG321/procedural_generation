# inventory_slot.gd
class_name InventorySlot
extends PanelContainer

@export var itemTexture: TextureRect

var slotItemData: ItemData

func Prepare_Slot(item: ItemData) -> void:
	slotItemData = item
	itemTexture.texture = item.texture
