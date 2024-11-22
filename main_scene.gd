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


@export_group("WeaponResources")
@export var rusty_pipe:WeaponResource


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
	unit_controller.log_append.connect(_on_log_appended)
	
	new_game_start_btn.button_up.connect(_on_new_game_start_btn_pressed)
	load_game_btn.button_up.connect(_on_load_game_btn_bressed)
	option_btn.button_up.connect(_on_option_btn_pressed)

	back_to_title_btn.button_up.connect(_on_back_to_title_btn_pressed)

	unit_controller.spawn_player()
	unit_controller.spawn_unit()


func _process(delta: float) -> void:
	mouse_pos = get_viewport().get_mouse_position()


func _exit_tree() -> void:
	thread.wait_to_finish()


func _on_new_game_start_btn_pressed() -> void:
	pass

func _on_load_game_btn_bressed() -> void:
	pass

func _on_option_btn_pressed() -> void:
	pass

func _on_back_to_title_btn_pressed() -> void:
	pass


func update_player_hp_progress(hp: int) -> void:
	player_hp_gauge.value = hp


func update_player_exp_progress(player_exp: int) -> void:
	exp_progress.value = player_exp


func _on_log_appended(msg: String):
	log_text_label.add_text(msg)
