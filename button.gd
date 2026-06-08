extends Button

@export var dep: int = 0;

signal World(Generated);

var locaciones = [
	{"nombre": "building",		"peso": 50, "loot": 60, "limite": 5},
	{"nombre": "house",			"peso": 25, "loot": 10, "limite": 8},
	{"nombre": "house_boarded",	"peso": 12, "loot": 20, "limite": 10},
	{"nombre": "well", 			"peso": 10, "loot": 40, "limite": 6},
	{"nombre": "camp",			"peso": 5, 	"loot": 50, "limite": 5},
	{"nombre": "bunker",		"peso": 2, 	"loot": 80, "limite": 25},
	{"nombre": "corpse",		"peso": 1, 	"loot": 5, 	"limite": 3}
]

var objetos = [
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
];

var limites = [
	{"dificultad": "Facil", "peso": 130},
	{"dificultad": "Normal", "peso": 150},
	{"dificultad": "Dificil", "peso": 180}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _pressed() -> void:
	var _World = {};
	var presupuesto = limites[2]["peso"];
	
	_World = Generate_World(presupuesto);
	World.emit(_World);	

func Generate_World(presupuesto) -> Dictionary:
	var _Final = {};
	var Locaciones_Temp = Generate_Item(presupuesto, locaciones);
	if dep == 1: print("\nGENERACION LOCACIONES TERMINADA -----------------");
	
	for loc in Locaciones_Temp:
		var Objetos_Temp = Generate_Item(loc["loot"], objetos);
		if dep == 1: print("GENERACION LOOT " + loc["nombre"] + " TERMINADA -----------------");
		
		_Final[loc["nombre"]] = [];
		
		for obj in Objetos_Temp:
			_Final[loc["nombre"]].append(obj["nombre"]);
	
	return _Final;

func Generate_Item(presupuesto: int, lista: Array) -> Array:
	var pesoTotal = 0;
	var _Seleccion = [];
	var _PesoTotal = 0;
	@warning_ignore("unused_variable")
	var limObj = 0;
	
	for i in range(lista.size()):
		pesoTotal += lista[i]["peso"];
	
	while presupuesto > 0:
		var tirada = randi_range(1, pesoTotal); 
		var locacionTemporal = {};
		
		for loc in lista:
			tirada -= loc["peso"];
			if tirada <= 0:
				locacionTemporal = loc;	
				break;
				
		
		if locacionTemporal["peso"] <= presupuesto:
			var loc = locacionTemporal;
			
			if loc["nombre"] == "Nada":
				presupuesto = 0;
			
			presupuesto -= loc["peso"];
			_Seleccion.append(loc);
		else:
			break;
	return _Seleccion;

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
