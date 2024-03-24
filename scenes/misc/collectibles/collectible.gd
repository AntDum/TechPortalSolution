class_name collectible extends Node2D

signal collected

@onready var animator = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		emit_signal("collected")
		print("emit collected")
	
