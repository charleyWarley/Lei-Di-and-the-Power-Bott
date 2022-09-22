extends Area2D

func _on_Area2D_body_entered(body):
	if body.name == "player": 
		get_parent().set_process(true)



func _on_Area2D_body_exited(body):
	if body.name == "player": 
		get_parent().set_process(false)
