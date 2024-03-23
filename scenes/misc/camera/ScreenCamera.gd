extends Camera2D

signal camera_moved(to: Vector2)

# Camera script follwing a target (usually the player)
# This camera is snapped to a grid, therefore only moves when the character exits a screen.

@export var target : NodePath
@export var screen_size := Vector2(1920, 1080)

@export var align_time : float = 4
@export var easing : Tween.EaseType = Tween.EASE_OUT

@onready var Target = get_node_or_null(target)

@onready var last_position = global_position

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(Target):
		var targets: Array = get_tree().get_nodes_in_group("Player")
		if targets: Target = targets[0]
	if not is_instance_valid(Target):
		return
	
	var new_position = desired_position()
	
	# Actual movement
	var tween = create_tween().set_ease(easing).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "global_position", new_position, align_time)
	
	var new_map_pos = (new_position / screen_size).floor()
	if new_map_pos != last_position:
		last_position = new_map_pos
		emit_signal("camera_moved", new_map_pos)

# Calculating the gridnapped position
func desired_position() -> Vector2:
	return (Target.global_position / screen_size).floor() * screen_size + screen_size/2
