extends CanvasLayer

@onready var sand_storm = $sand_storm

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enable_sand_storm():
	sand_storm.visible = true

func disable_sand_storm():
	sand_storm.visible = false
