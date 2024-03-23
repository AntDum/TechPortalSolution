extends Node2D

signal collected

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		emit_signal("collected")

func collect() -> void:
	hide()
	$Area2D.monitoring = false

func reset() -> void:
	show()
	$Area2D.monitoring = true
