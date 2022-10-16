extends Area2D



func _on_charley_body_entered(_body):
	if Input.is_action_just_pressed("interact"):
		print("create text box for dialogue")


func _on_charley_body_exited(_body):
	pass
