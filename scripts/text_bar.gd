extends Node2D

export(Resource) onready var sounds

var max_text_length : int = 45
var target_position : Vector2
var text_chunks : PoolStringArray
var displayed_text : String
var current_speaker : String
var up := Vector2(1, -55)
var down := Vector2(1, 16)
export(NodePath) onready var speaker_label = get_node(speaker_label) as Label
export(NodePath) onready var text_label = get_node(text_label) as Label 
export(NodePath) onready var sfx = get_node(sfx) as AudioStreamPlayer
export(NodePath) onready var timer = get_node(timer) as Timer
export(NodePath) onready var proceed = get_node(proceed) as ColorRect
onready var tween = $Tween


func _on_Timer_timeout():
	type(displayed_text.length())


func check_dialogues(speaker: String, text: String) -> void:
	if Dialogues.queue.has(text) or Dialogues.discard.has(text) or text == Dialogues.current_text:
		print("dialogue ignored")
		return
	Dialogues.current_text = text
	if Dialogues.isActive:
		Dialogues.add_to_queue(text)
		print(text, "added to queue")
		return
	if Dialogues.queue.has(text): 
		print("moving '", text, "' from queue to active box")
		Dialogues.remove_from_queue(text)
	if text.length() > max_text_length:
		print("text is too long")
		var chunk : String = ""
		for n in max_text_length:
			chunk += text[0]
			text.erase(0, 1)
		Dialogues.add_to_queue(text)
		text = chunk
	if Dialogues.queue.has(text): 
		print("moving '", text, "' from queue to active box")
		Dialogues.remove_from_queue(text)
	elif Dialogues.discard.has(text): 
		print("text already used")
		return
	Dialogues.set_active(true)
	timer.set_wait_time(Global.text_speed)
	timer.start()
	set_text(speaker, text)
	move_up()


func _ready():
	var _text_create_connect = Dialogues.connect("text_box_created", self, "check_dialogues")
	var _text_erase_connect = Dialogues.connect("text_box_gone", self, "move_down")
	set_process(false)
	proceed.set_visible(false)


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"): 
		sfx.set_stream(sounds.end)
		clear_text()


func move_up():
	sfx.set_stream(sounds.speaking)
	target_position = up
	tween.interpolate_property(self, "position",
		position, target_position, 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func move_down():
	if Dialogues.isActive or position == down: return
	sfx.set_stream(sounds.end)
	sfx.play()
	target_position = down
	tween.interpolate_property(self, "position",
		position, target_position, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func set_text(speaker: String, text: String) -> void:
	displayed_text = text
	if displayed_text == text_label.get_text() and text_label.visible_characters == displayed_text.length(): 
		print("cancelled text")
		return
	print("displaying: ", text)
	speaker_label.set_text(speaker)
	text_label.set_text(displayed_text)
	type(text.length())


func type(letters) -> void:
	if text_label.get_visible_characters() != letters:
		sfx.play()
		text_label.set_visible_characters(text_label.get_visible_characters() + 1)
		timer.start()
		return
	proceed.set_visible(true)
	set_process(true)


func clear_text():
	sfx.play()
	if Dialogues.queue.has(displayed_text): Dialogues.remove_from_queue(displayed_text)
	Dialogues.discard_text(displayed_text)
	text_label.set_text("")
	displayed_text = ""
	text_label.set_visible_characters(1)
	proceed.set_visible(false)
	Dialogues.set_active(false)
	set_process(false)
	if Dialogues.queue == Dialogues.empty: 
		print("queue is empty")
		move_down()
		current_speaker = ""
		speaker_label.set_text("")
	else:
		set_text(current_speaker, Dialogues.queue[0])
		print("queued text set to display")

