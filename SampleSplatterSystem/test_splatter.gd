extends Node2D


@export var max_part: int = 1000
@export var min_part: int = 750


var bd_arr: Array[Blood] = []


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var z_pos: Vector2 = get_global_mouse_position()
		for i in range(randi_range(max_part, min_part)):
			var bd:Blood = Blood.new(z_pos, randi_range(25, 100), Vector2(randf_range(5.0, 10.0), randf_range(-1.0, -5.0)), delta)
			bd_arr.append(bd)
	
	if bd_arr.size() > 0:
		for bd in bd_arr:
			if bd.is_freezed:
				bd_arr.erase(bd)
				bd.free()
			else:
				bd.velocity.x = lerpf(bd.velocity.x, 0.0, 0.155)
				bd.velocity.y = lerpf(bd.velocity.y, bd.max_fall_velocity, 0.155)

				bd.curr_pos += bd.velocity

				if bd.curr_cnt < bd.mx_cnt - bd.colliding_start_cnt:
					$Surface.draw_blood(bd.curr_pos)

				bd.curr_cnt -= 1

				if bd.curr_cnt == 0:
					bd.is_freezed = true


class Blood extends Object:
	
	var max_fall_velocity: float
	
	var force: float
	var velocity: Vector2
	var curr_pos: Vector2
	var colliding_start_cnt: int
	var colliding_mx_cnt: int
	var mx_cnt: int
	var curr_cnt: int
	
	var dir: Vector2
	
	var is_colliding: bool
	var is_freezed: bool

	func _init(curr_pos: Vector2, cnt: int, dir: Vector2, delta: float) -> void:
		self.curr_pos = curr_pos
		self.mx_cnt = randi_range(cnt - 15, cnt)
		self.curr_cnt = self.mx_cnt
		self.dir = dir
		self.max_fall_velocity = randf_range(0.3, 1.0)
		
		self.force = randf_range(20.0, 100.0)
		self.colliding_start_cnt = randi_range(8, cnt)
		self.is_colliding = false
	
		self.velocity = self.dir * self.force * delta
		self.is_freezed = false
