extends Node

signal world_changed(new_world)
signal player_loaded
signal camera_focused
signal camera_unfocused
signal player_exited_screen

var current_camera setget set_current_camera
var player : Actor = null
var scrap : int = 0
var cores : int = 0
var is_cameraSet := false
var text_speed : float = 0.1
var spawn_point
var temp_path : String = "res://scripts/saves/temp_save"
var music
var crt

func mute() -> void:
	if !music.is_playing():
		music.play()
		print("unmuted")
	else:
		music.stop()
		print("muted")

func set_spawn_point(node):
	spawn_point = node
	print("spawn point set")


func set_current_camera(camera: Camera2D):
	if current_camera == camera: 
		print("camera already set")
		return
	current_camera = camera
	current_camera.make_current()
	print("Global.current_camera set to initialized camera")
	
	
func probability(n: int) -> bool:
	#returns a probability of 1 / n
	randomize()
	var this_time : int = int(randf() * n)
	return this_time == 0


func reset_level() -> void:
	player = null
	is_cameraSet = false
	current_camera = null
	save()


func save():
	print("file saved")
	var data = {
		"spawn_point": spawn_point,
		"energy_cores": var2str(cores),
		"scrap_metal": var2str(scrap)
		}
	var file = File.new()
	file.open(temp_path, File.WRITE)
	file.store_string(var2str(data))
	file.close()


func load_previous_save():
	print("file loaded")
	var file = File.new()
	if !file.file_exists(temp_path): return null
	file.open(temp_path, File.READ)
	var data : String = file.get_as_text()
	file.close()
	return str2var(data)


