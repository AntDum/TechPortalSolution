extends HSlider

@export var bus_name:String
@onready var this_bus = AudioServer.get_bus_index(bus_name)
@onready var slider_noise = preload("res://assets/Sound/Sound_effect/HUD/Bruit_slider_2.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	value = AudioServer.get_bus_volume_db(this_bus)
	pass # Replace with function body.

func _on_value_changed(value):
	#Modifie le son
	AudioServer.set_bus_volume_db(this_bus, value)
	AudioServer.set_bus_mute(this_bus, value == -30) # Mute si mise à 0 du son
	
	#Joue du bruit pendant la modif
	AudioPlayer.play_fx(slider_noise,bus_name)
