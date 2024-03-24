extends Node2D

@export var one_way := true:
	get:
		return one_way
	
	set(value):
		$StaticBody2D/CollisionShape2D.one_way_collision = value
		one_way = value
@export var droppable := true
@export var destroyable := true

# Falling
@export_group("Falling parameters")
@export var destroy_after := 2.0
@export var reset_after := 5.0

@onready var Animator := $AnimationPlayer_falling
@onready var ShakeTimer := $ShakeTimer
@onready var ResetTimer := $ResetTimer

# One way
@onready var collision = $StaticBody2D/CollisionShape2D
@onready var area = $Area_oneway

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the timers
	ShakeTimer.wait_time = destroy_after
	ResetTimer.wait_time = reset_after
	
	collision.one_way_collision = one_way


# One way
func drop() -> void:
	if not droppable:
		return
	area.set_deferred("monitoring", true)

func _on_area_oneway_body_entered(_body):
	if not droppable:
		return
	collision.set_deferred("disabled", true)

func _on_area_oneway_body_exited(_body):
	if not droppable:
		return
	collision.set_deferred("disabled", false)
	area.set_deferred("monitoring", false)

# Destroyable
func _on_area_fall_body_entered(body):
	if not destroyable:
		return
	if body.name == "Player":
		if Animator.current_animation != "small_shake" and \
			Animator.current_animation != "shake":
			# Put the preshake animation
			Animator.play("small_shake")
			# Start the shake timer
			ShakeTimer.start()

func _on_shake_timer_timeout():
	if not one_way:
		return
	# Start the shaking animation
	Animator.play("shake")
	# Start the reset timer
	ResetTimer.start()


func _on_reset_timer_timeout():
	if not one_way:
		return
	# Reset the platform
	Animator.play("RESET")
	# Optionally, you can also reset the platform's position or other properties here
