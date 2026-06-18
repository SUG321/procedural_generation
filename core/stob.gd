class_name ObjDictionary
extends RefCounted

# DICCIONARIOS
static var ItemsTexts :Dictionary = {
	"backpack": preload("res://items/sprites/item_backpack.png"),
	"bag": preload("res://items/sprites/item_bag.png"),
	"clothes": preload("res://items/sprites/item_clothes.png"),
	"components": preload("res://items/sprites/item_components.png"),
	"food": preload("res://items/sprites/item_food.png"),
	"meds": preload("res://items/sprites/item_meds.png"),
	"metal": preload("res://items/sprites/item_metal.png"),
	"trash": preload("res://items/sprites/item_trash.png"),
	"water": preload("res://items/sprites/item_water.png"),
	"weapon": preload("res://items/sprites/item_weapon.png")
}
static var StructuresTexts :Dictionary = {
	"building": preload("res://structures/sprites/structure_building.png"),
	"house": preload("res://structures/sprites/structure_house.png"),
	"house_boarded": preload("res://structures/sprites/structure_house_boarded.png"),
	"well": preload("res://structures/sprites/structure_well.png"),
	"camp": preload("res://structures/sprites/structure_camp.png"),
	"bunker": preload("res://structures/sprites/structure_bunker.png"),
	"corpse": preload("res://structures/sprites/structure_corpse.png")
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
