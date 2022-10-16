extends Control

export(Resource) onready var worlds
export(NodePath) onready var viewcontainer = get_node(viewcontainer) as ViewportContainer
export(NodePath) onready var camera = get_node(camera) as Camera2D
export(NodePath) onready var crt = get_node(crt) as ColorRect
export(String) var start_world
export(NodePath) onready var music = get_node(music) as AudioStreamPlayer

export(PackedScene) onready var player
var world setget set_world

onready var viewport = viewcontainer.get_node("viewport")

var connected = false
var canPause = false


func _input(event) -> void:
	if not event is InputEventKey: return
	if event.pressed:
		if event.is_action("pause"):
			pause()
			return
		if event.is_action("fullscreen"): 
			OS.window_fullscreen = !OS.window_fullscreen
			return
		elif event.is_action("mute"): 
			Global.mute()
			return


func _ready():
	canPause = true
	var _world_change_connect = Global.connect("world_changed", self, "set_world")
	var _player_loaded_connect = Global.connect("player_loaded", self, "set_camera")
	set_deferred("world", start_world)
	Global.music = music
	music.play()
	Global.crt = crt


func set_world(location):
	match location:
		"level_one": 
			location = worlds.level_one
			camera.maxLimit = Vector2(2500, 650)
			camera.minLimit = Vector2(-1250, 0)
			load_level(location)
		"main_menu":
			location = worlds.main_menu
			camera.maxLimit = Vector2(100000, 100000)
			camera.minLimit = Vector2(-100000, -100000)
			load_level(location)


func load_level(newLevel):
	var level = newLevel.instance() 
	if Global.player == null:
		Global.player = player.instance() 
	if world != level: 
		if world != null:
			world.remove_child(Global.player)
			world.queue_free()
		world = level
		world.add_child(Global.player)
		viewport.add_child(level)
	if Global.current_camera: Global.current_camera.set_deferred("position", world.start_position.position)
	


func set_camera():
	camera.set_zoom(Vector2(1,1))
	camera.target = Global.player
	Global.set_current_camera(camera)
	Global.current_camera.set_deferred("position", world.start_position.position)
	
	


func pause() -> void:
	Global.reset_level()
	get_tree().call_deferred("reload_current_scene")
	#get_tree().set_pause(!get_tree().is_paused())



