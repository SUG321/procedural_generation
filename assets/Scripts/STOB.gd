class_name ObjDictionary
extends RefCounted

# DICCIONARIOS
static var ItemsTexts :Dictionary = {
	"backpack": preload("res://assets/items/item_backpack.png"),
	"bag": preload("res://assets/items/item_bag.png"),
	"clothes": preload("res://assets/items/item_clothes.png"),
	"components": preload("res://assets/items/item_components.png"),
	"food": preload("res://assets/items/item_food.png"),
	"meds": preload("res://assets/items/item_meds.png"),
	"metal": preload("res://assets/items/item_metal.png"),
	"trash": preload("res://assets/items/item_trash.png"),
	"water": preload("res://assets/items/item_water.png"),
	"weapon": preload("res://assets/items/item_weapon.png")
}
static var StructuresTexts :Dictionary = {
	"building": preload("res://assets/structures/structure_building.png"),
	"house": preload("res://assets/structures/structure_house.png"),
	"house_boarded": preload("res://assets/structures/structure_house_boarded.png"),
	"well": preload("res://assets/structures/structure_well.png"),
	"camp": preload("res://assets/structures/structure_camp.png"),
	"bunker": preload("res://assets/structures/structure_bunker.png"),
	"corpse": preload("res://assets/structures/structure_corpse.png")
}

# DICCIONARIOS
static var Structures :Array = [
	{"name": "building",		"weight": 50, 	"loot": 60, "limite": 5},
	{"name": "house",			"weight": 25, 	"loot": 10, "limite": 8},
	{"name": "house_boarded",	"weight": 12, 	"loot": 20, "limite": 10},
	{"name": "well", 			"weight": 10, 	"loot": 40, "limite": 6},
	{"name": "camp",			"weight": 5, 	"loot": 50, "limite": 5},
	{"name": "bunker",			"weight": 2, 	"loot": 80, "limite": 25},
	{"name": "corpse",			"weight": 1, 	"loot": 5, 	"limite": 3},
	{"name": "Null",			"weight": 30, 	"loot": 0, 	"limite": 0}
]
static var Items :Array = [
	{"name": "trash",		"weight": 40},
	{"name": "components",	"weight": 35},
	{"name": "metal",		"weight": 30},
	{"name": "bag",			"weight": 25},
	{"name": "clothes",		"weight": 20},
	{"name": "backpack",	"weight": 15},
	{"name": "weapon",		"weight": 10},
	{"name": "food",		"weight": 5},
	{"name": "meds",		"weight": 3},
	{"name": "water",		"weight": 2},
	{"name": "Null",		"weight": 20}
]
static var Dificults :Array = [
	{"dificult": "Facil", 	"weight": 130},
	{"dificult": "Normal", 	"weight": 150},
	{"dificult": "Dificil", "weight": 180}
]
