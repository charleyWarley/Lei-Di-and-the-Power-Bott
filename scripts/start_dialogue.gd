extends Area2D

export(String) onready var title
export(String) onready var text


func _on_focus_area_body_entered(body):
	if body.name != "player": return
	if text != "": 
		Dialogues.emit_signal("text_box_created", title, text)
		print("dialogue triggered")
	Global.emit_signal("camera_focused")
