extends AudioStreamPlayer


const menu_music = preload("res://assets/Sound/Music/Portal_main_theme.ogg")
const win_music = preload("res://assets/Sound/Music/cara_mia.ogg")
enum music {MENU, GAME, WIN, NONE}
var music_playing = music.NONE

@onready var m_voice = $Voice
@onready var m_basse = $Basse
@onready var m_cloche = $Cloche
@onready var m_v_long = get_node("Violon-long")
@onready var m_v_court = get_node("Violon-court")
@onready var sound_animator = $AnimationPlayer


func _process(_delta):
	if (music_playing == music.GAME and 
			m_voice.finished and m_basse.finished and m_cloche.finished and m_v_court.finished and m_v_court.finished
			):
		#_start_game_music()
		#print("restarting")
		pass
		
func _play_music(music: AudioStream):
	#if stream == music:
		#print("already same music")
		#return
	
	#sound_animator.play("RESET")
	stream = music
	play()
	
func play_music_menu():
	if music_playing == music.MENU:
		return
	music_playing = music.MENU
	_play_music(menu_music)

func play_win_music():
	music_playing = music.WIN
	_play_music(win_music)

func stop_music():
	if music_playing == music.MENU:
		print("stop menu music")
		sound_animator.play("menu_ease")
		stop()
	
	if music_playing == music.WIN:
		print("stop win music")
		sound_animator.play("menu_ease")
		stop()
	
	if music_playing == music.GAME:
		print("stop game music")
		sound_animator.play("game_ease")
		
	music_playing = music.NONE
	
func stop_music_menu():
	#For backward compatibility
	stop_music()

func play_game_music():
	music_playing = music.GAME
	sound_animator.play("RESET")
	m_voice.play()
	m_basse.play()
	m_cloche.play()	
	m_v_court.play()
	m_v_long.play()
	
		




func play_fx(stream_audio:AudioStream, bus: String = "SFX"):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream_audio
	fx_player.bus = bus
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
