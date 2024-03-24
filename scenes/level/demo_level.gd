extends Node2D


#
#func _on_screen_camera_camera_moved(to):
	#print(to)

func _ready():
	AudioPlayer.play_music_menu()
	AudioPlayer.stop_music()
	AudioPlayer.play_game_music()
	
