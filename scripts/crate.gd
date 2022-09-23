extends Breakable


func _ready():
	add_to_group("moveable")
	add_to_group("grabable")
	set_visible(false)

func _process(_delta):
	if rotation != 0: rotation = 0


func _on_VisibilityNotifier2D_screen_entered():
	set_visible(true)


func _on_VisibilityNotifier2D_screen_exited():
	set_visible(false)


