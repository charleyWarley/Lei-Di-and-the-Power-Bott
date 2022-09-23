extends Position2D

export(Vector2) onready var right_position
export(Vector2) onready var left_position
export(Vector2) onready var lift_position


func turn_right(ray):
	ray.set_cast_to(Vector2(6,0))
	position = right_position


func turn_left(ray):
	ray.set_cast_to(Vector2(-6,0))
	position = left_position

func lift():
	position = lift_position
