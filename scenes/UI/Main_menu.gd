extends Control


const SOUND_MENU_SCENE = "res://scenes/UI/Menu_son.tscn"

func _ready():
	AudioPlayer.play_music_menu()

func _on_music_sound_pressed():
	get_tree().change_scene_to_file(SOUND_MENU_SCENE)
