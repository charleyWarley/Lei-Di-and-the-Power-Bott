extends Collectible
class_name Core



func _on_Area2D_body_entered(body):
	if body.name != "player": return
	if Global.cores < Global.max_cores:
		collect()
		Global.cores += 1
		if Global.cores > Global.max_cores: Global.cores = Global.max_cores
	else:
		print("cores full")



