extends Control

const MAIN_MENU_SCENE = "res://scenes/UI/Main_menu.tscn"

func _ready():
	pass

func _on_retour_menu_pressed():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


