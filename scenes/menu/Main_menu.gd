extends Control


const SOUND_MENU_SCENE = "res://scenes/menu/Menu_son.tscn"
const MAIN_LVL = "res://scenes/level/main_level.tscn"



func _ready():
	await get_tree().process_frame
	print("ENTERING MENU")
	AudioPlayer.play_music_menu()

func _on_music_sound_pressed():
	get_tree().change_scene_to_file(SOUND_MENU_SCENE)



func _on_quit_pressed():
	#Coupe le son avant de quitter le jeu pour ne pas avoir une rupture soudaine
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file(MAIN_LVL)
	AudioPlayer.stop_music()
	AudioPlayer.play_game_music()
