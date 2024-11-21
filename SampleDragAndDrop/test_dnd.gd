extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var area_2d_2: Area2D = $Area2D2


func _ready() -> void:
	get_viewport().set_physics_object_picking_first_only(true)
	get_viewport().set_physics_object_picking_sort(true)
	
	area_2d.mouse_entered.connect(self._on_mouse_entered)
	area_2d_2.mouse_entered.connect(self._on_mouse_entered)
	area_2d.input_event.connect(self._on_input_event)
	area_2d_2.input_event.connect(self._on_input_event)
	

func _on_mouse_entered() -> void:
	print("mouse entered")

func _on_input_event(vp: Node, ev: InputEvent, shape_idx: int) -> void:
	if ev.is_action_pressed("mouse_l"):
		print("mouse left click")
