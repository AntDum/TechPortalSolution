extends Control

const MAIN_MENU_SCENE = "res://scenes/menu/Main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


func _on_button_pressed():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

