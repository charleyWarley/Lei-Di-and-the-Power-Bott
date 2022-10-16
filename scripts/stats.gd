extends Resource

enum drags {
	TURN = 25
	AIR = 28
	BASIC = 36
	STOP = 55
}

enum speeds {
	SLOW = 2
	WALK = 5
	RUN = 7
	CLIMB = 18
	MAX = 110
}

const GRAV : int = -13
const JUMP_BUFFER := 0.08
const LAND_BUFFER := 0.2

export(float) onready var pushForce
export(float) onready var throwForce
export(int) onready var speed
export(int) onready var jumpPower
export(int) onready var hp
export(int) onready var max_hp
