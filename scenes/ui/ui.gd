extends CanvasLayer

@export var storm_enable := true
	
@onready var sand_storm = $sand_storm
@onready var game_over = get_node("GameOver")
@onready var dead_fx = preload("res://assets/Sound/Sound_effect/Game/Bruit_dead.wav")

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


func _on_player_dead():
	#Add Game Over layer
	game_over.visible = true
	#disable mvt -> Done by removing the player
	#fx
	AudioPlayer.play_fx(dead_fx)
	pass # Replace with function body.
