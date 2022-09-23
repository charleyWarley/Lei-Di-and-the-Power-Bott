extends Lever

onready var trickles = $trickles
onready var waters = $water
onready var tween = $Tween

var vis : Color = Color(1,1,1,1)
var invis : Color = Color(1,1,1,0)
var canContinue := false


func _on_AnimationPlayer_animation_finished(_anim_name):
	if trickles.get_modulate() == vis: 
		canContinue = true
		water_valve(waters)
		return
	elif trickles.get_modulate() == invis:
		canContinue = true
		water_valve(trickles)


func _on_Tween_tween_completed(object, _key):
	if !canContinue: 
		print("can't continue")
		return
	print("continuing")
	canContinue = false
	water_valve(object)

func _ready():
	trickles.set_modulate(vis)
	waters.set_modulate(vis)


func water_valve(target: Node2D) -> void:
	if target.name == "trickles": target = waters
	else: target = trickles
	var from : Color
	var to : Color
	if target.get_modulate() == invis:
		from = invis
		to = vis
	else:
		from = vis
		to = invis
	tween.interpolate_property(target, "modulate",
		from, to, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
