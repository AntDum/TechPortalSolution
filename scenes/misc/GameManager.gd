extends Node

@export var player_path : NodePath
@onready var Player = get_node_or_null(player_path)

@export var camera_path : NodePath
@onready var Camera = get_node_or_null(camera_path)

@export var ui : NodePath
@onready var UI = get_node_or_null(ui)

var rooms : Dictionary

@export_category("Background") # Image to be used as background for each Biome
@export var background_desert : Texture
@export var background_ice : Texture
@export var background_lune : Texture