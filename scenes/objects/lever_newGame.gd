extends Lever

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "flip": 
		Global.emit_signal("world_changed", "level_one")
		Global.emit_signal("camera_unfocused")
		print("new game started")
	return
	
