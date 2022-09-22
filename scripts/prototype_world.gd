extends Node

export(NodePath) onready var start_position = get_node(start_position) as Position2D
var spawn_point
var isSpawned = false

func _ready():
	spawn_point = start_position

func _process(_delta):
	if Global.player != null and !isSpawned: 
		isSpawned = true
		Global.player.position = spawn_point.position
		set_process(false)
