extends Breakable


func _on_VisibilityEnabler2D_screen_entered():
	set_visible(true)


func _on_VisibilityEnabler2D_screen_exited():
	set_visible(false)


func _ready():
	add_to_group("moveable")
	add_to_group("grabable")
	set_visible(false)


