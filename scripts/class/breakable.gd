extends RigidBody2D
class_name Breakable

export(NodePath) onready var collision = get_node(collision) as CollisionShape2D
export(NodePath) onready var sfx = get_node(sfx) as AudioStreamPlayer
export(PackedScene) onready var contents
export(int) var hp

func _ready():
	add_to_group("breakable")


func take_damage():
	if sfx.is_playing(): return
	sfx.play()
	hp -= 1
	$Sprite.set_frame(1)
	if hp <= 0: 
		$Sprite.set_frame(2)


func destroy():
	if contents != null:
		var newItem = contents.instance()
		newItem.position = position
		get_parent().call_deferred("add_child", newItem)
	else: print("nothing inside")
	call_deferred("queue_free")


func _on_sfx_finished():
	if hp <= 0: 
		destroy()
