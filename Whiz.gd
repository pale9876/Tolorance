extends Node


enum State {
	shutdown = 0,
	whiz = 1,
	verbose = 2,
}


var state: State = State.shutdown


func lever_down(from: StringName, to: StringName) -> void:
	if state < State.whiz:
		print("%s -> %s", [from, to])


func whispering(msg: String) -> void:
	if state < State.shutdown:
		print("whisper: %s", [msg])


func observing(sgnl: Signal, msg: String) -> bool:
	await sgnl
	if state < State.whiz:
		print("%s has received:: %s", [sgnl.get_name(), msg])
	return true
