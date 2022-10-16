extends Area2D

export(String) onready var event

func _on_event_area_body_entered(body):
	if body.name != "player": return
	Global.current_camera.play_event(event)


func _on_event_area_body_exited(body):
	if body.name != "player" : return
	Global.current_camera.unfocus()
