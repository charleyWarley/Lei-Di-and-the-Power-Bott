extends Area2D


	
func _on_backpack_body_entered(body):
	if body.name != "player": return
	Global.emit_signal("screen_shook", 0.2, 15, 5)
	var rect = body.get_node("sprite").get_region_rect()
	match rect:
		Rect2(0, 0, 128, 48): body.get_node("sprite").set_region_rect(Rect2(0, 144, 128, 48))
		Rect2(0, 48, 128, 48): body.get_node("sprite").set_region_rect(Rect2(0, 96, 128, 48))
	Global.max_cores += 5
	Global.max_scrap += 10
	queue_free()

