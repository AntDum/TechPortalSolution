extends Control


const SOUND_MENU_SCENE = "res://scenes/menu/Menu_son.tscn"

func _ready():
	AudioPlayer.play_music_menu()

func _on_music_sound_pressed():
	get_tree().change_scene_to_file(SOUND_MENU_SCENE)



func _on_quit_pressed():
	#Coupe le son avant de quitter le jeu pour ne pas avoir une rupture soudaine
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	get_tree().quit()
