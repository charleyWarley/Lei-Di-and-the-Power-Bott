extends Area2D



func _on_end_dialogue_body_entered(body):
	if body.name == "player": Dialogues.emit_signal("text_box_gone")
