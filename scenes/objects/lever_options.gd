extends Lever

func _on_AnimationPlayer_animation_finished(anim_name):
	Global.crt.set_visible(!Global.crt.visible)
