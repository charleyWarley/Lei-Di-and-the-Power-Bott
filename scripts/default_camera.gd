extends Camera2D

var isLimitSet = false
var target = null
var isTargetSet = false
var maxLimit : Vector2
var minLimit : Vector2
var speed : Vector2
var targetPosition : Vector2
var normal_offset := offset
onready var tween = $Tween

func _input(_event) -> void:
	if Input.is_action_pressed("zoom"): zoom = Vector2(1.5,1.5)
	if Input.is_action_just_released("zoom"): zoom = Vector2(1,1)


func _ready():
	var _focus_connect = Global.connect("camera_focused", self, "focus")
	var _unfocus_connect = Global.connect("camera_unfocused", self, "unfocus")
	set_process(true)
	make_current()


func _process(delta) -> void:
	if !target: 
		print("camera missing target")
		return
	if !isTargetSet: 
		set_target()
	set_targetPosition()
	position.x = lerp(position.x, targetPosition.x, speed.x * delta)
	position.y = lerp(position.y, targetPosition.y, speed.y * delta)

func set_target():
	isTargetSet = true
	speed = Vector2(0.5, 0.5)


func set_targetPosition():	
	if !target.is_on_floor() or target.stats.speed == target.stats.speeds.RUN: speed = Vector2(1,1)
	else: speed = Vector2(0.5,0.5)
	if target.states.move_state == target.states.move_states.IDLE:
		if Input.is_action_pressed("move_up"): normal_offset.y =  -(get_viewport_rect().size.y * 0.35)
		elif Input.is_action_pressed("move_down"): normal_offset.y =  (get_viewport_rect().size.y * 0.2)
		else: normal_offset.y =  -(get_viewport_rect().size.y * 0.25)
	else: normal_offset.y = -(get_viewport_rect().size.y * 0.25)
	if target.isFacingRight: normal_offset.x = (get_viewport_rect().size.x * 0.15)
	else: normal_offset.x =  -(get_viewport_rect().size.x * 0.15)
	
	targetPosition = Vector2(target.position.x + normal_offset.x, target.position.y + normal_offset.y)
	if targetPosition.x < minLimit.x: targetPosition.x = minLimit.x
	if targetPosition.x > maxLimit.x: targetPosition.x = maxLimit.x
	if targetPosition.y < minLimit.y: targetPosition.y = minLimit.y
	if targetPosition.y > maxLimit.y: targetPosition.y = maxLimit.y


func focus():
	set_process(false)
	var focus_position : Vector2 = target.position
	focus_position.y = target.position.y - (get_viewport_rect().size.y * 0.08)
	tween.interpolate_property(self, "position",
		position, focus_position, 0.8,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func unfocus():
	if Dialogues.isActive: return
	set_process(true)
