extends Node2D

var direction
export(int) onready var speed
export(NodePath) onready var sfx = get_node(sfx) as AudioStreamPlayer

func move_spark(dir, aim):
	sfx.play()
	direction = aim
	match direction:
		Vector2(0,0): rotation = 0
		Vector2(0,1): 
			rotation = deg2rad(90.0)
			if !dir: 
				set_process(true)
				return
		Vector2(0,-1): 
			rotation = deg2rad(-90.0)
			if !dir: 
				set_process(true)
				return
		Vector2(1,-1): rotation = deg2rad(-45.0)
		Vector2(-1,-1): rotation = deg2rad(45.0)
		Vector2(-1,1): rotation = deg2rad(-45.0)
		Vector2(1,1): rotation = deg2rad(45.0)
		Vector2(1,0): rotation = 0
		Vector2(-1,0): rotation = 0
	if dir == true: $Sprite.set_flip_h(false)
	if dir == false: $Sprite.set_flip_h(true)
	set_process(true)


func _on_Area2D_body_entered(body):
	if body.is_in_group("breakable"):
		body.take_damage()
	$Area2D.queue_free()
	$Sprite.queue_free()


func _ready():
	set_process(false)


func _process(_delta):
	position += direction * speed


func _on_sfx_finished():
	queue_free()
