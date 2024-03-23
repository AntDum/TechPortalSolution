extends AudioStreamPlayer


const menu_music = preload("res://assets/Sound/Music/Portal_main_theme.ogg")

func _play_music(music: AudioStream):
	if stream == music:
		return
		
	stream = music
	play()
	
func play_music_menu():
	_play_music(menu_music)

func stop_music_menu():
	stop()
	
func play_fx(stream_audio:AudioStream, bus: String = "SFX"):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream_audio
	fx_player.bus = bus
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
