extends Button
# EXPORTS Y MODULOS
@export var dep: int = 0;
@onready var TextBox = $"../Seed"

# SEÑALES
signal World(Generated);

# MAQUINAS Y VARIABLES
var rng = RandomNumberGenerator.new()
var ruido = FastNoiseLite.new()

var mapa = {}

var locaciones = [
	{"nombre": "building",		"peso": 50, "loot": 60, "limite": 5},
	{"nombre": "house",			"peso": 25, "loot": 10, "limite": 8},
	{"nombre": "house_boarded",	"peso": 12, "loot": 20, "limite": 10},
	{"nombre": "well", 			"peso": 10, "loot": 40, "limite": 6},
	{"nombre": "camp",			"peso": 5, 	"loot": 50, "limite": 5},
	{"nombre": "bunker",		"peso": 2, 	"loot": 80, "limite": 25},
	{"nombre": "corpse",		"peso": 1, 	"loot": 5, 	"limite": 3},
	{"nombre": "Nada",			"peso": 30, "loot": 0, 	"limite": 0}
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
	
	var _Seed = TextBox.text.hash()
	rng.seed = _Seed
	ruido.seed = _Seed
	ruido.noise_type = FastNoiseLite.TYPE_PERLIN
	ruido.frequency = 0.08
	
	Generate_Map(30, 20)
	
	_World = Generate_World(presupuesto);
	World.emit(_World);	
	

func Generate_Map(ancho: int, alto: int):
	mapa.clear()
	if dep>= 2: print("\n...INIT GEN MAPA")
	
	for y in range(alto):
		var fila = ""
		for x in range(ancho):
			var valor = ruido.get_noise_2d(x, y)
			var prespCelda = 0
			var icono = ""
			
			if valor > 0.3:
				prespCelda = 80
				icono = "██"
			elif valor > 0.0:
				prespCelda = 30
				icono += "▒▒"
			else:
				prespCelda = 10
				icono += ".."
			
			fila += icono
			
			var genLocs = Generate_Item(prespCelda, locaciones)
			if genLocs.size() > 0:
				var prinLoc = genLocs[0]
				if prinLoc["nombre"] != "Nada":
					var genObjs = Generate_Item(prinLoc["loot"], objetos)
					var listLoot = []
					for obj in genObjs:
						listLoot.append(obj["nombre"])
					mapa[Vector2(x, y)] = {
						"estructura": prinLoc["nombre"],
						"loot": listLoot
					}
		print(fila)

	if dep >= 1: print("\nGENERACION MAPA TERMINADA -----------------");
	if dep >= 2: print("\nEl mundo tiene ", mapa.size(), " locaciones con loot")
	
	if dep >= 3:
		var test_coord = Vector2(10, 10)
		if mapa.has(test_coord):
			print("\nEn la coordenada ", test_coord, " hay: ", mapa[test_coord]["estructura"])
			print("Contiene este loot: ", mapa[test_coord]["loot"])
		else:
			print("\nLa coordenada ", test_coord, " es un terreno vacío.")
	

func Generate_World(presupuesto) -> Dictionary:
	var _Final = {};
	var Locaciones_Temp = Generate_Item(presupuesto, locaciones);
	if dep >= 1: print("\nGENERACION LOCACIONES TERMINADA -----------------");
	
	for loc in Locaciones_Temp:
		var Objetos_Temp = Generate_Item(loc["loot"], objetos);
		if dep >= 1: print("GENERACION LOOT " + loc["nombre"] + " TERMINADA -----------------");
		
		_Final[loc["nombre"]] = [];
		
		for obj in Objetos_Temp:
			_Final[loc["nombre"]].append(obj["nombre"]);
	
	return _Final;

func Generate_Item(presupuesto: int, lista: Array) -> Array:
	var pesoTotal = 0;
	var _Seleccion = [];
	
	for i in range(lista.size()):
		pesoTotal += lista[i]["peso"];
	
	while presupuesto > 0:
		var tirada = rng.randi_range(1, pesoTotal); 
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
