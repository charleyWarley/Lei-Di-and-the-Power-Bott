extends Label

func _process(_delta):
	if get_text() != str(Global.scrap): set_text(str(Global.scrap))
