extends collectible

signal repaired

var game_manager

func _on_collected():
	if game_manager.can_repair_generator():
		emit_signal("repaired")
		animator.play("generator_fixed")
