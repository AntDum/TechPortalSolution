extends Button

@onready var button_pressed_fx = preload("res://assets/Sound/Sound_effect/HUD/HUD_bouton_presse1.wav")
@onready var button_hovered_fx = preload("res://assets/Sound/Sound_effect/HUD/HUD_bouton_presse3-Survole.wav")


func _on_pressed():
	AudioPlayer.play_fx(button_pressed_fx)



func _on_mouse_entered():
	AudioPlayer.play_fx(button_hovered_fx)
