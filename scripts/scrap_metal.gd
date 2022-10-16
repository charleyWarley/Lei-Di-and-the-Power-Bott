extends Collectible
class_name Scrap

export(NodePath) onready var sprite = get_node(sprite) as Sprite
var scrap = 1

func _on_Area2D_body_entered(body):
	if body.name != "player": return
	if Global.scrap < Global.max_scrap:
		collect()
		Global.scrap += scrap
		if Global.scrap > Global.max_scrap: Global.scrap = Global.max_scrap
	else:
		print("scrap full")


func _ready():
	var flip1 = Global.probability(2)
	var flip2 = Global.probability(4)
	var flip3 = Global.probability(8)
	var flip4 = Global.probability(16)
	var flip5 = Global.probability(32)
	if flip5: 
		sprite.set_frame(4)
		scrap = 10
	elif flip4: 
		sprite.set_frame(3)
		scrap = 6
	elif flip3: 
		sprite.set_frame(2)
		scrap = 4
	elif flip2: 
		sprite.set_frame(1)
		scrap = 2
	elif flip1: 
		sprite.set_frame(0)
		scrap = 1
