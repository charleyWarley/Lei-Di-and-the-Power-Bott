extends KinematicBody2D

const GRAVITY : int = 68
export(int) var speed
export(int) var attack
export(int) var hp

var direction := Vector2(-1, 0)
var t : float = 0.3
var isLeftFree := false
var isRightFree := false
var isFlipped := true
export(bool) onready var canMirror
onready var sprite = $Sprite
onready var sfx = $sfx
export(PackedScene) onready var contents
export(NodePath) onready var collision_shape = get_node(collision_shape) as CollisionShape2D
var fall_collision = null


func _on_VisibilityNotifier2D_viewport_entered(_viewport): 
	self.set_visible(true)
	set_process(true)
func _on_VisibilityNotifier2D_viewport_exited(_viewport): 
	self.set_visible(false)


func _ready():
	self.set_visible(false)
	add_to_group("enemies")


func _process(_delta):
	rotation = 0
	if isLeftFree and !isRightFree: isFlipped = true
	elif isRightFree and !isLeftFree: isFlipped = false
	if canMirror: sprite.set_flip_h(isFlipped)


func _physics_process(_delta):
	var velocity : Vector2
	rotation = 0
	if !visible: return
	if !is_on_floor(): velocity.y = GRAVITY
	else: velocity.y = 0
	check_flip()
	velocity.x = lerp(velocity.x, speed * direction.x, t)
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	check_collisions()

func check_flip():
	if isFlipped and direction.x != -1: direction.x = -1
	elif !isFlipped and direction.x != 1: direction.x = 1
	
func check_collisions():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var collider = collision.collider
		check_blocked(collision.normal.x)
		check_free(collision.normal.x)
		if collider.name == "player":
			if collision.normal.y != 1: 
				var dir = collision.normal
				collider.take_damage(dir)


func check_blocked(normal):
	if normal == 1: isLeftFree = false
	elif normal == -1: isRightFree = false


func check_free(normal):
	if normal != -1: isRightFree = true
	if normal != 1: isLeftFree = true


func take_damage():
	if sfx.is_playing(): return
	sfx.play()
	hp -= 1
	collision_shape.queue_free()


func _on_sfx_finished():
	queue_free()
