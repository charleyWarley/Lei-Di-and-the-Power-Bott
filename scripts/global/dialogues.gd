extends Node

signal text_box_created(title, text)
signal text_box_gone

var isActive := false
var discard : PoolStringArray
var queue : PoolStringArray
var empty : PoolStringArray
var current_text

func discard_text(text) -> void:
	discard.append(text)
	print("current discard:")
	print(discard)

func set_active(state: bool) -> void:
	isActive = state

func add_to_queue(text) -> void:
	queue.append(text)
	print("current queue:")
	print(queue)
	
func remove_from_queue(text) -> void:
	queue.remove(queue.find(text))
	print("current queue:")
	print(queue)
