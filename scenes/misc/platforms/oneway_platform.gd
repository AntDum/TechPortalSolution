extends Node2D

@onready var collision = $StaticBody2D/CollisionShape2D
@onready var area = $Area2D

func drop() -> void:
	area.set_deferred("monitoring", true)

func _on_area_2d_body_entered(_body):
	collision.set_deferred("disabled", true)

func _on_area_2d_body_exited(_body):
	collision.set_deferred("disabled", false)
	area.set_deferred("monitoring", false)
