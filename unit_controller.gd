extends Node
class_name UnitController


signal log_append(msg: String)

signal update_player_atk_time_progress(value: float)
signal update_player_hp_progress(value: int)

@export_group("PhantomCamera")
@export var phantom_camera: PhantomCamera2D

@export_group("UnitResources")
@export var model_123:UnitResource
@export var nuigurumi:UnitResource

@export_group("Unit2DBaseScenes")
@export var models: Dictionary = {
	"base_chara" : preload("res://unit_2d.tscn")
}

var player: Player

var units: Array[Unit]
var enemies: Array[Unit]


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	
	for unit in units:
		if unit is Player:
			if enemies.size() > 0:
				unit.atk_time -= delta * unit.atk_spd
				update_player_atk_time_progress.emit( unit.atk_time / unit.default_atk_time )
		else:
			if player != null:
				unit.atk_time -= delta * unit.atk_spd


func _on_player_level_up(max_exp: int) -> void:
	log_append.emit(("Player Level Up : %d" % player.player_lv))


func _on_player_death(unit: Unit) -> void:
	unit.is_dead = true

	player.player_level_up.disconnect(_on_player_level_up)
	player.attack.disconnect(_on_player_attacked)
	player.death.disconnect(_on_player_death)

	player = null
	
	units.erase(unit)
	
	await get_tree().create_timer(2.0, false, true, false).timeout

	unit.body.call_deferred("queue_free")
	unit.call_deferred("queue_free")


func _on_player_attacked(player: Unit, damage: int) -> void:
	if enemies.size() > 0:
		enemies[0].hp -= damage
		
		log_append.emit("Player attacked %d damage to -> %s" % [damage, str(enemies[0].name)])

func _on_unit_attacked(unit:Unit, damage: int) -> void:
	if player.hp != 0 and not player.is_dead:
		player.hp -= damage
		log_append.emit("%s attacked Player! damaged: %d" % [str(unit.name), damage])
		player.player_health_changed.emit(player.hp)


func _on_unit_death(unit: Unit) -> void:
	unit.is_dead = true
	
	if unit in enemies:
		enemies.erase(unit)
		units.erase(unit)
	
	if player != null:
		player.get_exp(unit.exp)
	
	unit.spawned_unit_cnt -= 1

	await get_tree().create_timer(1.0, false, true, false).timeout
	
	unit.body.queue_free()

	unit.call_deferred("queue_free")


func spawn_unit(
				unit_res: UnitResource = nuigurumi,
					model: PackedScene = models.base_chara,
						at_node2d: Node2D = get_tree().get_first_node_in_group("EnemySpawnMarks")
							) -> void:
	
	var unit: Unit = Unit.new(unit_res, model, at_node2d)
	add_child(unit)
	
	unit.body.hp_progress.max_value = unit.max_hp
	unit.body.hp_progress.value = unit.hp
	
	units.append(unit)
	enemies.append(unit)
	
	unit.attack.connect(self._on_unit_attacked)
	unit.death.connect(self._on_unit_death)

	phantom_camera.append_follow_targets(unit.body)


class Unit extends Node:

	static var spawned_unit_cnt: int = 0
	
	signal death(unit: Unit)
	signal attack(unit:Unit, damage: int)
	signal health_changed(unit: Unit)

	var is_dead: bool

	var unit_name: String
	var unit_lv: int = 1
	var unit_type: UnitResource.UnitType
	var atk_type: WeaponResource.WeaponType
	var max_hp: int = 10
	var hp: int = 1:
		set(value):
			hp = clamp(value, 0, max_hp)
			if hp == 0:
				if not is_dead:
					health_changed.emit(hp)
					death.emit(self)
			else:
				health_changed.emit(hp)
	var atk: int = 1
	var def: int = 1
	var atk_spd: float = 1.0
	var exp: int = 10

	var default_atk_time: float = 2.0
	var atk_time: float = 2.0:
		set(value):
			atk_time = maxf(value, 0.0)
			if atk_time == 0.0:
				attack.emit(self, atk)
				atk_time = default_atk_time

	var body: Unit2D
	var hsm: LimboHSM

	func _init(
			unit_stats: UnitResource,
				unit_scene: PackedScene,
					spawn_node2d: Node2D
						) -> void:
		self.is_dead = false
		
		self.unit_lv = unit_stats.lv
		self.unit_type = unit_stats.unit_type
		self.max_hp = unit_stats.max_hp
		self.hp = self.max_hp
		self.atk = unit_stats.atk
		self.def = unit_stats.def
		self.atk_spd = unit_stats.atk_spd
		self.exp = unit_stats.exp
		
		self.body = unit_scene.instantiate()
		spawn_node2d.add_child(self.body)

		self.health_changed.connect(self.body.update_health)

		spawned_unit_cnt += 1

	func idle_entered() -> void:
		pass

	func idle_updated(delta: float) -> void:
		pass

	func move_entered() -> void:
		pass

	func move_update(delta: float) -> void:
		pass

	func hurt_entered() -> void:
		pass

	func hurt_updated(delta: float) -> void:
		pass

	func _init_hsm(ct: Node2D) -> void:
		self.hsm = LimboHSM.new()

		var idle: LimboState = create_state(self.idle_entered, self.idle_updated, &"Idle")
		var move: LimboState = create_state(self.move_entered, self.move_update, &"Move")
		var attk: LimboState = create_state(self.attk_entered, self.attk_updated, &"Attk")
		var hurt: LimboState = create_state(self.hurt_entered, self.hurt_updated, &"Hurt")

		self.hsm.add_child(idle)
		self.hsm.add_child(move)
		self.hsm.add_child(attk)
		self.hsm.add_child(hurt)

		self.hsm.initialize(self)
		self.hsm.set_active(true)

		ct.add_child(self.hsm)

	func create_state(ec: Callable, up: Callable, st_name: StringName) -> LimboState:
		Whiz.whispering("Create Unit State: %s" % str(st_name))
		return LimboState.new().call_on_enter(ec).call_on_update(up)

	class Weapon extends Object:

		var weapon_type: WeaponResource.WeaponType
		var current_weapon_nm: StringName
		var weapon_atk_pt: int
		var weapon_atk_spd: float

		func _init(wp: WeaponResource) -> void:
			self.weapon_type = wp.weapon_type
			self.current_weapon_nm = wp.weapon_name
			self.weapon_atk_pt = wp.atk_point
			self.weapon_atk_spd = wp.atk_spd_point

		func get_weapon_type() -> String:
			match self.weapon_type:
				WeaponResource.WeaponType.knives:
					return "날붙이"
				WeaponResource.WeaponType.soul:
					return "령"
				WeaponResource.WeaponType.blunt:
					return "둔기"
				WeaponResource.WeaponType.kinesis:
					return "염동력"
				_:
					return "WeaponType :: 알 수 없는 무기타입"

class Player extends Unit:

	signal player_level_up(max_exp: int)
	signal player_exp_changed(value: int)
	signal player_health_changed(value: int)

	static var player_cnt: int

	var player_lv: int = 1
	var player_max_exp: int = 100
	var player_exp: int = 0:
		set(value):
			player_exp = clamp(value, 0, player_max_exp)
			if player_exp == player_max_exp:
				player_lv += 1
				player_exp = 0
				player_max_exp += player_lv * 100
				player_level_up.emit(player_max_exp)
			else:
				self.player_exp_changed.emit(player_exp)

	var atk_spd_pt: float:
		set(value):
			atk_spd_pt = maxf(value, 0.0)
			atk_spd = atk_spd + atk_spd_pt

	var weapon: Weapon

	func _init(
			player_stats: UnitResource,
				weapon_res: WeaponResource,
					unit_scene: PackedScene,
						spawn_node2d: Node2D
							) -> void:

		self.weapon = Weapon.new(weapon_res)

		
		self.max_hp = player_stats.max_hp
		self.atk = player_stats.atk + self.weapon.weapon_atk_pt
		self.def = player_stats.def
		self.atk_spd = player_stats.atk_spd + self.weapon.weapon_atk_pt
		
		self.hp = self.max_hp

		self.body = unit_scene.instantiate()
		self.body.is_player = true
		
		self.is_dead = false

		spawn_node2d.add_child(self.body)

	func get_exp(value: int) -> void:
		self.player_exp += value
