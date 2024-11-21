extends Node2D

const dummy_net_adaptor = preload("res://addons/delta_rollback/DummyNetworkAdaptor.gd")


@onready var ip_edit: LineEdit = %IpEdit
@onready var port_edit: LineEdit = %PortEdit

@onready var server_host_button: Button = %ServerHostButton
@onready var server_join_button: Button = %ServerJoinButton


var logging_enable: bool = false



func _ready() -> void:
	multiplayer.peer_connected.connect( _on_peer_connected )
	multiplayer.peer_disconnected.connect( _on_peer_disconnected )
	multiplayer.connected_to_server.connect( _on_server_connected )
	multiplayer.server_disconnected.connect( _on_server_disconnected )

	SyncManager.sync_started.connect( _on_syncmanager_sync_started )
	SyncManager.sync_stopped.connect( _on_syncmanager_sync_stopped )
	SyncManager.sync_lost.connect( _on_syncmanager_sync_lost )
	SyncManager.sync_regained.connect( _on_syncmanager_sync_regained )
	SyncManager.sync_error.connect( _on_syncmanager_sync_error )

	server_host_button.button_up.connect( _on_server_host_btn_pressed )
	server_join_button.button_up.connect( _on_server_join_btn_pressed )

	var cmdline_args = OS.get_cmdline_args()
	if "server" in cmdline_args:
		pass


func _on_server_host_btn_pressed() -> void:
	pass


func _on_server_join_btn_pressed() -> void:
	pass


func _on_peer_connected( id: int ) -> void:
	pass


func _on_peer_disconnected( id: int ) -> void:
	pass


func _on_server_connected() -> void:
	pass


func _on_server_disconnected() -> void:
	pass



func _on_syncmanager_sync_started() -> void:
	pass


func _on_syncmanager_sync_stopped() -> void:
	pass


func _on_syncmanager_sync_lost() -> void:
	pass


func _on_syncmanager_sync_regained() -> void:
	pass


func _on_syncmanager_sync_error() -> void:
	pass

class Player extends Node:
	func _init() -> void:
		pass
	
	func _get_local_input() -> Dictionary:
		var input: Dictionary = {}
		return input
		
		var x = Input.get_action_strength("") - Input.get_action_strength("")
		
