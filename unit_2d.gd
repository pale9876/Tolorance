extends CharacterBody2D
class_name Unit2D

@export var grav: float = 970.0

@onready var hp_progress: ProgressBar = $"HpProgress"

var is_player: bool = false

var is_grabbed: bool
var grabbed_by: Node2D

var move_spd: float = 400.0


func _ready() -> void:

	var _hsm: LimboHSM = LimboHSM.new()
	add_child(_hsm)

	#TODO: Add States
	var _idle: LimboState = LimboState.new().named("Idle").call_on_enter(self._idle_entered)
	_hsm.add_child(_idle)

	_hsm.initialize(self)
	_hsm.set_active(true)
	
	if is_player:
		hp_progress.hide()


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y = clampf(velocity.y + grav * delta, 0.0, grav)
	
	move_and_slide()


func forcebacked(force: float, dir: Vector2) -> void:
	pass

func _idle_entered() -> void:
	pass
	
func update_health(hp: int) -> void:
	hp_progress.value = hp
