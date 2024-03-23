extends Node2D

# Falling
@onready var Animator := $AnimationPlayer
@onready var ShakeTimer := $ShakeTimer
@onready var ResetTimer := $ResetTimer

# One way
@onready var collision = $StaticBody2D/CollisionShape2D
@onready var area = $Area_oneway

@export var shake_delay := 2.0
# Time to wait before the platform resets
@export var reset_delay := 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the timers
	ShakeTimer.wait_time = shake_delay
	ResetTimer.wait_time = reset_delay


func drop() -> void:
	area.set_deferred("monitoring", true)

func _on_area_fall_body_entered(body):
	if body.name == "Player":
		# Put the preshake animation
		Animator.play("small_shake")
		# Start the shake timer
		ShakeTimer.start()


func _on_area_oneway_body_entered(_body):
	collision.set_deferred("disabled", true)

func _on_area_oneway_body_exited(_body):
	collision.set_deferred("disabled", false)
	area.set_deferred("monitoring", false)


func _on_shake_timer_timeout():
	# Start the shaking animation
	Animator.play("shake")
	# Start the reset timer
	ResetTimer.start()


func _on_reset_timer_timeout():
	# Reset the platform
	Animator.play("RESET")
	# Optionally, you can also reset the platform's position or other properties here
