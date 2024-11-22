extends Node
class_name SamplePlayerDecker


@export var action_resources: Dictionary = {}


@export var player_deck: Array[ActionCard]
@export var player_max_deck: int = 6


class ActionCard extends Node:
	var action_frame: int
	var action_resource

	func _init() -> void:
		pass
