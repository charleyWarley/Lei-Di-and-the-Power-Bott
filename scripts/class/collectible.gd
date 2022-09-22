extends Node2D
class_name Collectible

onready var area = $Area2D
onready var sfx = $sfx


func _on_sfx_finished():
		queue_free()


func _ready():
	set_process(false)


func _process(delta):
	position.y -= 45 * delta


func collect():
	set_process(true)
	area.queue_free()
	sfx.play()
