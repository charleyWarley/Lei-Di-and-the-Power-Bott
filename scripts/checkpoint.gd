extends Node2D

onready var anim_player = $AnimationPlayer
onready var sfx = $sfx
onready var spawn_point = $spawn_point


func _on_Area2D_body_entered(body):
	if body.name != "player": return
	Global.spawn_point = spawn_point
	set_process(true)

func _on_Area2D_body_exited(body):
	if body.name != "player": return
	set_process(false)

func _ready():
	set_process(false)
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"): save_progress()

func save_progress() -> void:
	anim_player.play("save_game")
	Global.save()
	sfx.play()



