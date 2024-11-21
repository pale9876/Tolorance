extends Resource
class_name WeaponResource

enum WeaponType {
	none,
	knives,
	soul,
	blunt,
	kinesis,
}

@export var weapon_name: StringName = ""
@export var weapon_type: WeaponType
@export var atk_point: int = 1
@export var atk_spd_point: float = 0.1
