class_name ObjDictionary
extends RefCounted

# DICCIONARIOS
static var ItemsTexts = {
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
static var StructuresTexts = {
	"building": preload("res://assets/locations/location_building.png"),
	"house": preload("res://assets/locations/location_house.png"),
	"house_boarded": preload("res://assets/locations/location_house_boarded.png"),
	"well": preload("res://assets/locations/location_well.png"),
	"camp": preload("res://assets/locations/location_camp.png"),
	"bunker": preload("res://assets/locations/location_bunker.png"),
	"corpse": preload("res://assets/locations/location_corpse.png")
}
static var Structures = [
	{"nombre": "building",		"peso": 50, "loot": 60, "limite": 5},
	{"nombre": "house",			"peso": 25, "loot": 10, "limite": 8},
	{"nombre": "house_boarded",	"peso": 12, "loot": 20, "limite": 10},
	{"nombre": "well", 			"peso": 10, "loot": 40, "limite": 6},
	{"nombre": "camp",			"peso": 5, 	"loot": 50, "limite": 5},
	{"nombre": "bunker",		"peso": 2, 	"loot": 80, "limite": 25},
	{"nombre": "corpse",		"peso": 1, 	"loot": 5, 	"limite": 3},
	{"nombre": "Nada",			"peso": 30, "loot": 0, 	"limite": 0}
]
static var Items = [
	{"nombre": "trash",				"peso": 40},
	{"nombre": "components",		"peso": 35},
	{"nombre": "metal",				"peso": 30},
	{"nombre": "bag",				"peso": 25},
	{"nombre": "clothes",			"peso": 20},
	{"nombre": "backpack",			"peso": 15},
	{"nombre": "weapon",			"peso": 10},
	{"nombre": "food",				"peso": 5},
	{"nombre": "meds",				"peso": 3},
	{"nombre": "water",				"peso": 2},
	{"nombre": "Nada",				"peso": 20}
]
static var Dificults = [
	{"dificultad": "Facil", "peso": 130},
	{"dificultad": "Normal", "peso": 150},
	{"dificultad": "Dificil", "peso": 180}
]
