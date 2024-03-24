extends Control



const MAIN_MENU_SCENE = "res://scenes/menu/Main_menu.tscn"


func _ready():
	visible = false



func _on_button_pressed():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)



# Called when the node ent
