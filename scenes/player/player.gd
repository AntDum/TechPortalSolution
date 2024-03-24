extends CharacterBody2D
## Code from the demo available in the godot asset lib
## Modified by AntDum 23/03/2024
## This character controller was created with the intent of being a decent starting point for Platformers.
## 
## Instead of teaching the basics, I tried to implement more advanced considerations.
## That's why I call it 'Movement 2'. This is a sequel to learning demos of similar a kind.
## Beyond coyote time and a jump buffer I go through all the things listed in the following video:
## https://www.youtube.com/watch?v=2S3g8CgBG1g
## Except for separate air and ground acceleration, as I don't think it's necessary.

signal dead

# BASIC MOVEMENT VARIABLES ---------------- #
var face_direction := 1
var x_dir := 1

@export_group("Basic mouvement") 
@export var default_max_speed: float = 560
@export var default_acceleration: float = 2880
@export var default_turning_acceleration : float = 9600
@export var default_deceleration: float = 3200
var max_speed: float = default_max_speed
var acceleration: float = default_acceleration
var turning_acceleration: float = default_turning_acceleration
var deceleration: float = default_deceleration
# ------------------------------------------ #


# GRAVITY ----- #
@export_group("Gravity") 
@export var default_gravity_acceleration : float = 3840
@export var default_gravity_max : float = 1020
var gravity_acceleration : float = default_gravity_acceleration
var gravity_max : float = default_gravity_max
# ------------- #

# JUMP VARAIABLES ------------------- #
@export_group("Jump") 
@export var default_jump_force : float = 1400
@export var default_jump_cut : float = 0.25
@export var default_jump_gravity_max : float = 500
@export var default_jump_hang_treshold : float = 2.0
@export var default_jump_hang_gravity_mult : float = 0.1
var jump_force : float = default_jump_force
var jump_cut : float = default_jump_cut
var jump_gravity_max : float = default_jump_gravity_max
var jump_hang_treshold : float = default_jump_hang_treshold
var jump_hang_gravity_mult : float = default_jump_hang_gravity_mult
# Timers
@export_subgroup("Timer") 
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1


# ------------------------------------------ #
@export_group("Map effects")
@export_subgroup("Iced mouvement")
@export var iced_max_speed: float = 780
@export var iced_deceleration: float = 2
@export var iced_turning_acceleration: float = 3200

@export_subgroup("Moon mouvement")
@export var moon_max_speed: float = 560
@export var moon_deceleration: float = 3200
@export var moon_turning_acceleration: float = 3200
@export var moon_gravity_acceleration : float = 3840/3
@export var moon_oxygen_reserve : float = 30.0


var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
# ----------------------------------- #



# ----------------------------------- #


@onready var left_ray = $RayCast2DLeft
@onready var right_ray = $RayCast2DRight

# All iputs we want to keep track of
func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		# "y": int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("jump")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true
	}

func _process(delta):
	$Label.text = String.num($OxygenCounter.time_left,2)

func _physics_process(delta: float) -> void:
	x_movement(delta)
	jump_logic(delta)
	apply_gravity(delta)
	
	platform_collide()
	
	timers(delta) 
	move_and_slide()
	
func platform_collide() -> void:
	if left_ray.is_colliding() or right_ray.is_colliding():
		var collision = null
		if left_ray.is_colliding():
			collision = left_ray.get_collider().get_parent()
		elif right_ray.is_colliding():
			collision = right_ray.get_collider().get_parent()
			
		if collision.has_method("drop") and Input.is_action_pressed("down"):
			collision.drop()


func put_on_ice(on: bool) -> void:
	if on:
		max_speed = iced_max_speed
		deceleration = iced_deceleration
		turning_acceleration = iced_turning_acceleration
	else:
		max_speed = default_max_speed
		deceleration = default_deceleration
		turning_acceleration = default_turning_acceleration
	

func x_movement(delta: float) -> void:
	x_dir = get_input()["x"]
	
	# Stop if we're not doing movement inputs.
	if x_dir == 0: 
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0,0), deceleration * delta).x
		return
	
	# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
	# Except if we are turning
	# (This keeps our momentum gained from outside or slopes)
	if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		return
	
	# Are we turning?
	# Deciding between acceleration and turn_acceleration
	var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	
	# Accelerate
	velocity.x += x_dir * accel_rate * delta
	
	set_direction(x_dir) # This is purely for visuals


func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return
	#apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	face_direction = hor_direction # remember direction


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if is_on_floor():
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if get_input()["just_jump"]:
		jump_buffer_timer = jump_buffer
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
		
		velocity.y = -jump_force
	
	# We're not actually interested in checking if the player is holding the jump button
#	if get_input()["jump"]:pass
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling
	if get_input()["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)
	
	# This way we won't start slowly descending / floating once hit a ceiling
	# The value added to the treshold is arbritary,
	# But it solves a problem where jumping into 
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 100.0


func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return
	
	# Normal gravity limit
	if velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnececary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta


func _on_room_entered(biome1 : Room.Biome, biome2 : Room.Biome) -> void:
	if biome1 == Room.Biome.ICE || biome2 == Room.Biome.ICE:
		put_on_ice(true)
	else:
		put_on_ice(false)

func _on_area_2d_body_entered(_body):
	get_killed()
	
	
func suffocate():
	$Label.visible = true
	if($OxygenCounter.is_stopped()):
		$OxygenCounter.start(moon_oxygen_reserve)
	max_speed = moon_max_speed
	deceleration = moon_deceleration
	turning_acceleration = moon_turning_acceleration
	gravity_acceleration = moon_gravity_acceleration
	#
	#if AudioPlayer.playing == false:
		#AudioPlayer.play()
	#
	
func breathe():
	$Label.visible = false
	$OxygenCounter.stop()
	max_speed = default_max_speed
	deceleration = default_deceleration
	turning_acceleration = default_turning_acceleration
	gravity_acceleration = default_gravity_acceleration
	
	#AudioPlayer.stop()
	
func get_killed():
	print("YOU JUST DIEEEEED")
	dead.emit()
	queue_free()

