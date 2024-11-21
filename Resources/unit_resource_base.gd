extends Resource
class_name UnitResource

enum UnitType {
	none,
	light,
	middle,
	heavy,
	titan,
}

@export var unit_name:String = "Unknown Character"

@export_group("Stats")
@export var lv: int = 1
@export var unit_type: UnitType = UnitType.middle
@export var max_hp: int = 100
@export var atk: int = 1
@export var def: int = 1
@export var atk_spd: float
@export var exp: int = 10

@export_group("Sprite")
@export var texture: Texture2D
