extends Lever

onready var icon = $icon

func _on_AnimationPlayer_animation_finished(_anim_name):
	Global.mute()
	if Global.music.is_playing(): icon.set_frame(0)
	else: icon.set_frame(1)
