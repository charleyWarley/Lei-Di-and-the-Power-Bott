extends Node2D
class_name Lever

onready var anim_player = $AnimationPlayer
onready var sfx = $sfx

func _ready():
	set_process(false)


func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		anim_player.play("flip")
		if !sfx.is_playing(): sfx.play()



