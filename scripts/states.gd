extends Resource

enum move_states {
	IDLE,
	TURNING,
	WALKING,
	RUNNING,
	AIR
}
var move_state = move_states.WALKING

enum ground_states {
	GROUNDED,
	AIRBORNE,
}
var ground_state = ground_states.AIRBORNE

enum depth_states {
	TOP,
	MID,
	LOW
}
var depth_state = depth_states.TOP
