extends Node2D

@onready var Animator := $AnimationPlayer
@onready var ShakeTimer := $ShakeTimer
@onready var ResetTimer := $ResetTimer

@export var shake_delay := 2.0
# Time to wait before the platform resets
@export var reset_delay := 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the timers
	ShakeTimer.wait_time = shake_delay
	ResetTimer.wait_time = reset_delay

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		# Put the preshake animation
		Animator.play("small_shake")
		# Start the shake timer
		ShakeTimer.start()

func _on_ShakeTimer_timeout():
	# Start the shaking animation
	Animator.play("shake")
	# Start the reset timer
	ResetTimer.start()

func _on_ResetTimer_timeout():
	# Reset the platform
	Animator.play("RESET")
	# Optionally, you can also reset the platform's position or other properties here
