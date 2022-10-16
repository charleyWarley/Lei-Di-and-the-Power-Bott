extends RigidBody2D
class_name Breakable

export(NodePath) onready var collision = get_node(collision) as CollisionShape2D
export(NodePath) onready var sfx = get_node(sfx) as AudioStreamPlayer
export(PackedScene) onready var contents
export(int) var hp


func _ready() -> void:
	add_to_group("breakable")


func enable() -> void:
	set_mode(RigidBody2D.MODE_RIGID)
	collision.set_disabled(false)
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE


func disable() -> void:
	set_mode(RigidBody2D.MODE_STATIC)
	collision.set_disabled(true)
	continuous_cd = RigidBody2D.CCD_MODE_DISABLED
	rotation = 0


func take_damage() -> void:
	Global.emit_signal("screen_shook", 0.2, 15, 5)
	if sfx.is_playing(): return
	sfx.volume_db = 0
	sfx.play()
	hp -= 1
	$Sprite.set_frame(1)
	if hp <= 0: 
		$Sprite.set_frame(2)


func destroy() -> void:
	if contents != null:
		var newItem = contents.instance()
		newItem.position = position
		get_parent().call_deferred("add_child", newItem)
	else: print("nothing inside")
	call_deferred("queue_free")


func _on_sfx_finished() -> void:
	sfx.volume_db = 0
	if hp <= 0: 
		destroy()

func _on_crate_body_entered(_body):
	pass #figure out how to find the collision normal to get the dot product and aplify the sound based on the throw
