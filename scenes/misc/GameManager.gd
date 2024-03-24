extends Node

@onready var RoomMaker = %Map

@export var player_path : NodePath
@onready var Player = get_node_or_null(player_path)

@export var camera_path : NodePath
@onready var Camera = get_node_or_null(camera_path)

@export var ui : NodePath
@onready var UI = get_node_or_null(ui)

var rooms : Dictionary

@export var room : PackedScene

func _ready() -> void:
	# Wait one frame to make sure the player is ready
	await get_tree().process_frame

	var biome = Room.get_random_biome(Room.Biome.NULL)
	var coord := Vector2(0, 0)
	var from_sub_type = Room.SubRoomType.IV
	create_map(biome, coord, from_sub_type)

func portal_entered(pos: Vector2, biome :Room.Biome, sub_room_type: Room.SubRoomType) -> void:
	create_map(biome, pos, sub_room_type)

func create_map(biome : Room.Biome, coord : Vector2, from_sub_type : Room.SubRoomType) -> void:
	var coord_i = Room.get_position_subroom(coord, from_sub_type, Room.SubRoomType.I)
	RoomMaker.place_room(coord_i, biome, from_sub_type)


func register_room(pos: Vector2, biome: Room.Biome) -> void:
	rooms[str(pos)] = biome

func get_room(pos: Vector2) -> Room.Biome:
	return rooms.get(str(pos), Room.Biome.NULL)



func _on_screen_camera_camera_moved(to):
	var biome = get_room(to)
	if biome == Room.Biome.NULL:
		await get_tree().process_frame
		biome = get_room(to)
	
	if biome == Room.Biome.DESERT:
		UI.enable_sand_storm()
	else:
		UI.disable_sand_storm()
