extends Node


func _ready() -> void:
	var samp: Sample = Sample.new()
	var unit: Unit = Unit.new()
	
	unit.call_deferred("free")
	samp.call_deferred("free")



func _process(delta: float) -> void:
	pass


class Sample:
	var count: int = 1

class Unit extends Sample:
	var ex_count: int = 1
