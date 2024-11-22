extends Node2D

enum TitleState {
	main_menu,
	in_game,
}

@export_group("Controllers")
@export var unit_controller: UnitController

@export_group("Marks")
@export var player_position:Node2D
@export var enemy_position:Node2D
@export var enemy_position_2:Node2D
@export var enemy_position_3:Node2D

@onready var phantom_camera: PhantomCamera2D = $"PhantomCamera2D"

@onready var title_ui: Control = %TitleUI
@onready var game_ui: Control = %GameUI

@onready var character_name: Label = %CharacterName
@onready var weapon_name: Label = %WeaponName
@onready var exp_progress: ProgressBar = %ExponentProgress
@onready var atk_time_progress: ProgressBar = %AttackTimeProgress
@onready var player_hp_gauge: TextureProgressBar = %HpGauge

@onready var new_game_start_btn: Button = %NewGameStartBtn
@onready var load_game_btn: Button = %LoadGameButton
@onready var option_btn: Button = %OptionButton

@onready var back_to_title_btn: Button = %BacktoTitleBtn
@onready var log_text_label: RichTextLabel = %LogTextLabel


var thread: Thread

var mouse_pos: Vector2


func _ready() -> void:
	unit_controller.update_player_hp_progress.connect( _update_player_hp_progress )
	unit_controller.update_player_atk_time_progress.connect( _update_player_exp_progress )
	unit_controller.log_append.connect( _on_log_appended )
	unit_controller.player_spawned.connect( _on_player_spawned )

	new_game_start_btn.button_up.connect(_on_new_game_start_btn_pressed)
	load_game_btn.button_up.connect(_on_load_game_btn_bressed)
	option_btn.button_up.connect(_on_option_btn_pressed)

	back_to_title_btn.button_up.connect(_on_back_to_title_btn_pressed)

	unit_controller.spawn_player()
	unit_controller.spawn_unit()


func _process(delta: float) -> void:
	mouse_pos = get_viewport().get_mouse_position()


func _exit_tree() -> void:
	if thread.is_started():
		thread.wait_to_finish()


func _on_new_game_start_btn_pressed() -> void:
	pass

func _on_load_game_btn_bressed() -> void:
	pass

func _on_option_btn_pressed() -> void:
	pass

func _on_back_to_title_btn_pressed() -> void:
	pass

func _update_player_hp_progress(hp: int) -> void:
	player_hp_gauge.value = hp

func _update_player_exp_progress(value: int) -> void:
	exp_progress.value = value

func _on_player_level_up(value: int) -> void:
	pass

func _on_player_death() -> void:
	pass


func _on_log_appended(msg: String):
	log_text_label.append_text(msg + "\n")


func _on_player_spawned(player: Node) -> void:
	player_hp_gauge.max_value = player.max_hp
	player_hp_gauge.value = player.hp

	atk_time_progress.value = player.atk_time / player.default_atk_time

	exp_progress.max_value = player.player_max_exp
	exp_progress.value = player.player_exp

	player.player_level_up.connect( _on_player_level_up )
	player.player_health_changed.connect( _update_player_hp_progress )
	player.player_exp_changed.connect( _update_player_exp_progress )
	player.death.connect( _on_player_death )
