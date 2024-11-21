extends BTAction

@export var dist_max: float = 40.0
@export var dist_min: float = 10.0

@export var pos_var:StringName = &"pos"
@export var dir_var:StringName = &"dist"

var points = [-1, 1]

func _tick(delta: float) -> Status:
	
	var dir: float = random_dir()
	
	var pos: Vector2 = random_pos(dir)
	
	
	return SUCCESS

func random_pos(dir: float) -> Vector2:
	var dist: float = randf_range(dist_min, dist_max) * dir
	var ahead_pos: float = dist + agent.global_position.x
	return Vector2(ahead_pos, 0.0)

func random_dir() -> float:
	randomize()

	var dir: float = float(points.pick_random() as int)

	blackboard.set_var(dir_var, dir)
	return dir
