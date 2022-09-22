extends Collectible
class_name Core



func _on_Area2D_body_entered(body):
	if body.name != "player": return
	collect()
	Global.cores += 1



