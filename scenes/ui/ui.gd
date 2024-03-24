extends CanvasLayer

@export var storm_enable := true
	
@onready var sand_storm = $sand_storm
@onready var game_over = get_node("GameOver")
@onready var item_animator = $Collectible_UI/AnimationPlayer
@onready var win = get_node("Win")

@onready var dead_fx = preload("res://assets/Sound/Sound_effect/Game/Bruit_dead.wav")
@onready var desert_sound = preload("res://assets/Sound/Sound_effect/Game/Bruits_vent_sifflement.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	if storm_enable:
		enable_sand_storm()
	else:
		disable_sand_storm()

func enable_sand_storm():
	sand_storm.visible = true
	#AudioPlayer.play_fx(desert_sound)

func disable_sand_storm():
	sand_storm.visible = false


func _on_player_dead():
	#Add Game Over layer
	game_over.visible = true
	#disable mvt -> Done by removing the player
	#fx
	AudioPlayer.stop_music()
	AudioPlayer.play_fx(dead_fx)
	
	

func _on_game_manager_item_collected(item):
	if item == "wrench":
		item_animator.play("wrench_apparition") 
	if item == "stone":
		item_animator.play("stone_apparition") 
			

func _on_game_manager_generator_fixed():
	win.visible = true
	AudioPlayer.stop_music()
	AudioPlayer.play_win_music()
	
