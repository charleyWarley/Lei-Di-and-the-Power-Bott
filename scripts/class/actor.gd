extends KinematicBody2D
class_name Actor

export(Resource) onready var stats
export(Resource) onready var states
export(Resource) onready var sounds

var isFacingRight := true
var wasGrounded := false
var isFalling := false

var items_in_hand : Array
var direction : Vector2
var velocity : Vector2
var bounceForce : Vector2
var walk_mode = "dirt"
var state_machine = null
var lastCollider = null

export(NodePath) onready var sfx = get_node(sfx) as AudioStreamPlayer
export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var ray = get_node(ray) as RayCast2D
export(NodePath) onready var pickupSpot = get_node(pickupSpot) as Position2D

func _ready() -> void:
	stats.hp = stats.max_hp
	state_machine = $AnimationTree.get("parameters/playback")
	
func get_cur_time() -> float: 
	return OS.get_ticks_msec() / 1000.0

func take_damage(_dir) -> void:
	state_machine.travel("take_damage")
	play_sound(sounds.damage0)
	stats.hp -= 1
	if stats.hp <= 0: 
		Global.cores -= 1
		stats.hp = stats.max_hp


func walk_sound() -> void:
	match walk_mode:
		"dirt": play_sound(sounds.walk0)
		"water": play_sound(sounds.walk1)

func play_sound(sound) -> void:
	sfx.set_stream(sound)
	sfx.play()

func set_walk(mode: String) -> void:
	walk_mode = mode

func animation_check() -> void:
	match states.move_state:
		states.move_states.AIR:
			return
		states.move_states.WALKING: 
			if animate_jump(): return
			state_machine.travel("walk")
		states.move_states.TURNING: 
			state_machine.travel("turn")
		states.move_states.RUNNING:
			if animate_jump(): return
			state_machine.travel("run")
		states.move_states.IDLE:
			if animate_jump(): return
			state_machine.travel("idle")
			animate_actions()


func animate_jump() -> bool:
	if wasGrounded and Input.is_action_just_pressed("jump"): 
		state_machine.travel("jump")
		return true
	return false


func animate_actions() -> void:
	if Input.is_action_pressed("move_down"):
		state_machine.travel("duck")
	if Input.is_action_pressed("move_up"): 
		state_machine.travel("look_up")
		return
	if Input.is_action_just_pressed("hit"):
		state_machine.travel("hit")
	if Input.is_action_just_pressed("interact"):
		state_machine.travel("interact")
