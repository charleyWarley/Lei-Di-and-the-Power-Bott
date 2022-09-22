extends Label

func _process(_delta):
	if get_text() != str(Global.cores): set_text(str(Global.cores))
