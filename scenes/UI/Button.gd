extends Button

@onready var button_fx = preload("res://assets/Sound/Sound_effect/HUD_bouton_presse1.wav")


func _on_pressed():
	AudioPlayer.play_fx(button_fx)
