extends collectible

func _on_collected():
	animator.play("generator_fixed")
