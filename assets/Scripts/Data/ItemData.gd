# ItemData.gd
class_name ItemData
extends Resource

@export var id: String = "" # "trash", "weapon", ...
@export var displayName: String = "" # "Chatarra", "Arma", ...
@export var texture: Texture2D # PNG
@export var spawnWeight: int = 10 # QUE TAN COMUN ES QUE APAREZCA: ALTO/COMUN-BAJO/RARO

@export var maxStack: int = 10 # CUANTOS OBJETOS CABEN
@export var type: String = "material" # "consumable",  "weapon", "material, ...
