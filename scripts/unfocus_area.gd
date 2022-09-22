extends Area2D



func _on_unfocus_area_body_entered(body):
	if body.name != "player": return
	if get_parent().text != "": 
		Dialogues.emit_signal("text_box_gone")
	Global.emit_signal("camera_unfocused")
