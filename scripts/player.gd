extends Actor
export(PackedScene) onready var hitSpark
var timePressedJump : float = 0.0
var timePressedHit : float = 0.0
var timeLeftGround : float = 0.0
var sparks : int = 0
var canRun := true

func _input(_event) -> void:
	check_actions()


func _process(_delta) -> void:
	direction = check_direction()
	animation_check()
	check_collisions()


func _physics_process(delta) -> void:
	var isGrounded = is_on_floor()
	var drag : float = set_drag(isGrounded)
	set_velocity(isGrounded, drag, delta)
	wasGrounded = isGrounded


func set_drag(isGrounded: bool) -> float:
	var drag : float = 0.0
	if isGrounded:
		states.ground_state = states.ground_states.GROUNDED
		#var direction.x : float = Input.get_axis("move_left", "move_right")
		#var direction.y : float = Input.get_axis("move_up", "move_down")
		check_flip(direction.x, direction.y)
		
		if abs(direction.x) == 0.0: 
			states.move_state = states.move_states.IDLE
			drag = float(stats.drags.STOP)
		elif sign(direction.x) != sign(velocity.x) and velocity.x != 0: 
			states.move_state = states.move_states.TURNING
			drag = float(stats.drags.TURN)
		else:
			if Input.is_action_pressed("run") and canRun: 
				states.move_state = states.move_states.RUNNING
			else: states.move_state = states.move_states.WALKING
			drag = float(stats.drags.BASIC)
	else: 
		states.move_state = states.move_states.AIR
		drag = float(stats.drags.AIR)
	drag *= 0.01
	return drag
	
	
func check_direction() -> Vector2:
	direction = Vector2()
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	direction = direction.normalized()
	return direction


func set_velocity(isGrounded: bool, drag: float, delta: float) -> void:
	velocity.x += direction.x * stats.speed
	velocity = Vector2(check_x(drag, delta), check_y(isGrounded))
	if abs(velocity.x) > stats.speeds.MAX: 
		var dir = sign(velocity.x)
		velocity.x = stats.speeds.MAX * dir
	var targetVelocity = get_target_velocity()
	velocity = velocity.linear_interpolate(targetVelocity, 0.1)
	velocity += bounceForce
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	set_deferred("bounceForce", Vector2.ZERO)


func check_x(drag, delta) -> float:
	velocity.x *= pow(1 - drag, delta * 10)
	return velocity.x


func check_y(isGrounded: bool) -> float:
	if velocity.y < -375: velocity.y = -375
	if !isGrounded:
		states.ground_state = states.ground_states.AIRBORNE
		if wasGrounded: timeLeftGround = get_cur_time()
	else: states.ground_state = states.ground_states.GROUNDED
	var pressedJump = Input.is_action_just_pressed("jump")
	var releasedJump = Input.is_action_just_released("jump")
	if releasedJump and sign(velocity.y) == -1:
		velocity.y *= 0.4
	elif pressedJump:
		timePressedJump = get_cur_time()
		if states.ground_state == states.ground_states.GROUNDED: jump()
		elif get_cur_time() - timeLeftGround < stats.JUMP_BUFFER:
			jump()
	else: 
		velocity.y -= stats.GRAV
	if states.ground_state != states.ground_states.GROUNDED and velocity.y > 0: 
		isFalling = true
	var timeDifference = get_cur_time() - timePressedJump
	if states.ground_state == states.ground_states.GROUNDED:
		isFalling = false
		if velocity.y > 0: 
			states.ground_state = states.ground_states.AIRBORNE
			velocity.y = 0.1
	elif !wasGrounded and states.ground_state == states.ground_states.GROUNDED and timeDifference < stats.JUMP_BUFFER:
		jump()
	return velocity.y


func get_target_velocity() -> Vector2:
	if direction.x == 0:
		if velocity.x > -10 and velocity.x < 10: velocity.x = 0
	return velocity


func jump() -> void:
	sfx.volume_db = 0
	play_sound(sounds.jump0)
	velocity.y = stats.jumpPower


func check_collisions() -> void:
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var collider = collision.collider
		if collision.normal.y == 1 and collider.is_in_group("breakable"):
				collider.call_deferred("take_damage")
				return
		elif collision.normal.y == -1:
			if isFalling and get_cur_time() - timeLeftGround > stats.LAND_BUFFER:
				if states.ground_state == states.ground_states.AIRBORNE: states.ground_state = states.ground_states.GROUNDED
				isFalling = false
				#Global.emit_signal("screen_shook", 0.2, 11, 1)
				walk_sound()
				if collider.is_in_group("enemies"): 
					bounceForce.y = -120
					play_sound(sounds.effort1)
					collider.call_deferred("take_damage")
					return
				if Input.is_action_pressed("move_down"): 
					if collider.is_in_group("breakable"): 
						play_sound(sounds.effort0)
						collider.call_deferred("take_damage")
						return
		elif collider.is_in_group("moveable"): collider.apply_central_impulse(-collision.normal * stats.pushForce)


func check_flip(h, _v) -> void:
	if h == 0: return
	if !isFacingRight and h == 1:
		pickupSpot.turn_right(ray)
		isFacingRight = true
		sprite.set_flip_h(false)
	elif isFacingRight and h == -1:
		pickupSpot.turn_left(ray)
		isFacingRight = false
		sprite.set_flip_h(true)
	if !canRun:
		ray.set_enabled(false)
		pickupSpot.lift()


func check_actions() -> void:
	if Input.is_action_just_pressed("hit"): 
		hit()
	elif Input.is_action_just_pressed("use_ability"): 
		use_ability()
	elif Input.is_action_pressed("interact"):
		if Input.is_action_just_pressed("interact"):
			stats.speed = stats.speeds.SLOW
			grab()
	if Input.is_action_just_pressed("change_ability"): 
		Abilities.change_current_ability()
	elif Input.is_action_just_released("use_ability"): 
		deactivate_ability()
	if Input.is_action_pressed("run") and canRun: stats.speed = stats.speeds.RUN
	elif Input.is_action_just_released("run"): 
		states.move_state = states.move_states.WALKING
		stats.speed = stats.speeds.WALK
	if Input.is_action_just_released("interact"): 
		ungrab("set_down")
		states.move_state = states.move_states.WALKING
		stats.speed = stats.speeds.WALK


func hit() -> void:
	if ray.get_collider() != null:
		var collider = ray.get_collider()
		if collider is RigidBody2D: 
			var dir : int
			if isFacingRight: dir = 1
			else: dir = -1
			collider.apply_central_impulse(Vector2(stats.throwForce/4 * dir, 0))
			collider.take_damage()
			return
	play_sound(sounds.effort0)
	spark()


func use_ability() -> void: 
	if items_in_hand != []:
		ungrab("throw")
	print("ability activated")
	return


func deactivate_ability() -> void:
	print("ability deactivated")
	return


func grab() -> void:
	var collider = ray.get_collider()
	if !collider: return
	if collider.is_in_group("grabable"):
		print("grabbing")
		pickup_item(collider)
	if collider.is_in_group("stealable"):
		print("stealing")
		pickup_item(collider.contents)


func ungrab(followup) -> void:
	stats.speed = stats.speeds.WALK
	if items_in_hand == []: return
	var item = items_in_hand[0]
	var dir : int 
	if isFacingRight: dir = 1
	else: dir = -1
	if item != null:
		item.get_parent().remove_child(item)
	get_parent().add_child(item)
	item.enable()
	match followup: 
		"throw": 
			item.position.y = position.y - 8
			item.position.x = position.x + (8 * dir)
			item.apply_central_impulse(Vector2(stats.throwForce * dir, 0))
			item.take_damage()
		"set_down": 
			item.position.x = position.x + (16 * dir)
			item.position.y = position.y - 8
	items_in_hand.remove(0)
	canRun = true
	Abilities.isGrabbing = false
	ray.set_enabled(true)
	if isFacingRight: pickupSpot.turn_right(ray)
	else: pickupSpot.turn_left(ray)


func pickup_item(item) -> void:
	if items_in_hand.has(item) or items_in_hand.size() >= 1: 
		print("hands are full")
		return
	items_in_hand.append(item)
	item.get_parent().remove_child(item)
	if item is RigidBody2D: 
		item.disable()
	pickupSpot.add_child(item)
	canRun = false
	pickupSpot.lift()
	item.set_deferred("position", pickupSpot.position)
	
	print("holding ", item.name)


func spark() -> void:
	var newSpark : Node2D = hitSpark.instance()
	get_parent().add_child(newSpark)
	newSpark.position = position
	if isFacingRight:
		newSpark.position.x += 12
		newSpark.get_node("Sprite").flip_h = true
	else: newSpark.position.x -= 12
	newSpark.move_spark(isFacingRight, direction)



func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	Global.emit_signal("player_exited_screen")


func _on_sfx_finished():
	sfx.volume_db = 0
