extends Sprite2D

func set_shader_step(step : float):
	material.set_shader_parameter("dissolve_threshold", step)
