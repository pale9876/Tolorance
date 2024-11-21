extends BTAction
@export var target_pos_var: StringName = &"pos"
@export var dir_var: StringName = &"dir"

@export var spd_var = 40
@export var tolerance = 10

func _tick(delta: float) -> Status:
	var target_pos: Vector2
	
	return SUCCESS
