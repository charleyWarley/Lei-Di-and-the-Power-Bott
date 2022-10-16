tool
extends Sprite


func calculate_aspect_ratio() -> void:
	material.set_shader_param("aspect_ratio", scale.y / scale.x)

