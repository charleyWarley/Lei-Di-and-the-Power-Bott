extends Node

var isSpawned = false
export(NodePath) onready var start_position = get_node(start_position) as Position2D

func _process(_delta):
	if Global.player != null and !isSpawned: 
		print("player spawned")
		isSpawned = true
		Global.player.position = start_position.position
		Global.emit_signal("player_loaded")
