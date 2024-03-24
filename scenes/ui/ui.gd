extends CanvasLayer

@export var storm_enable := true
	
@onready var sand_storm = $sand_storm

# Called when the node enters the scene tree for the first time.
func _ready():
	if storm_enable:
		enable_sand_storm()
	else:
		disable_sand_storm()

func enable_sand_storm():
	sand_storm.visible = true

func disable_sand_storm():
	sand_storm.visible = false
