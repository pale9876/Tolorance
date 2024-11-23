extends Node
class_name SamplePlayerDecker

@export var card_deck_ui: Control
@export var action_resources: Dictionary = {
	&"Wait" : preload("res://SampleIngameSystem/wait.tres")
}



@export var deck_panels: Array[Panel]
var player_cards: Array[ActionCard]

@onready var player_max_deck: int = deck_panels.size()


func _ready() -> void:
	for i in range(player_max_deck):
		player_cards.append(ActionCard.new(action_resources.Wait, deck_panels[i]))

	


func _physics_process(delta: float) -> void:
	if player_cards.size() > 0:
		player_cards[0].action_frame -= 1
		if player_cards[0].action_frame == 0:
			player_cards.pop_front()


class ActionCard extends Node:
	const card_scene: PackedScene = preload("res://SampleIngameSystem/card.tscn")
	
	var action_frame: int
	var card_resource: ActionCardResource
	var card: Card
	
	func _init(a_res: ActionCardResource, deck_ui: Control) -> void:
		self.card = card_scene.instantiate()
		deck_ui.add_child(self.card)

		self.action_frame = a_res.action_frame
		self.card.anim.animation_finished.connect(on_animation_finished)
	
	func on_animation_finished(anim_name: StringName) -> void:
		if anim_name == &"CardEntering":
			self.card.queue_free()
			queue_free()
	
