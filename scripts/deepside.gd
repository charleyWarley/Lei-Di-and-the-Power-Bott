extends Area2D

func _on_deepside_body_entered(body):
	body.set_modulate(Color.red)


func _ready():
	set_visible(false)


func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	set_visible(true)


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	set_visible(false)
