extends Area2D


func _on_water_body_entered(body):
	if body.name == "player":
		body.set_walk("water")
		


func _on_water_body_exited(body):
	if body.name == "player":
		body.set_walk("dirt")
