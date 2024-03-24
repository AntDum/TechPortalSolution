extends Node

signal room_entered(biome1 : Room.Biome, biome2 : Room.Biome)
signal item_collected(item:String) #wrench or stone

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
	create_map(biome, coord, from_sub_type, true)
	self.connect("room_entered", Player._on_room_entered)
	self.connect("room_entered", self._on_room_entered)

func portal_entered(pos: Vector2, biome :Room.Biome, sub_room_type: Room.SubRoomType) -> void:
	print("Portal open")
	create_map(biome, pos, sub_room_type, false)
	var biomes = get_room(pos)
	emit_signal("room_entered", biomes[0], biomes[1])

func create_map(biome : Room.Biome, coord : Vector2, from_sub_type : Room.SubRoomType, first_map : bool) -> void:
	
	var coord_i = Room.get_position_subroom(coord, from_sub_type, Room.SubRoomType.I)
	var new_biome = Room.get_random_biome(biome)
	print("From " + str(from_sub_type) + " to " + str(Room.SubRoomType.I) + " at " + str(coord))
	print("Creating room at " + str(coord_i) + " with biome " + str(new_biome))
	RoomMaker.place_room(coord_i, new_biome, Room.reverse_subroom(from_sub_type), first_map)


func register_room(pos: Vector2, biome: Room.Biome) -> void:
	print("Registering room at " + str(pos) + " with biome " + str(biome))
	# If the room is already registered
	if rooms.has(str(pos)):
		# If the room is already registered with the same biome
		if rooms[str(pos)][0] == biome:
			assert(false, "Room already registered")
		if rooms[str(pos)][1] != Room.Biome.NULL:
			assert(false, "Room already registered")
		rooms[str(pos)][1] = biome
	else:
		rooms[str(pos)] = [biome, Room.Biome.NULL]

func get_room(pos: Vector2) -> Array:
	return rooms.get(str(pos), [Room.Biome.NULL, Room.Biome.NULL])

func is_room_registered(pos: Vector2) -> bool:
	return rooms.has(str(pos))

func is_room_full(pos: Vector2) -> bool:
	return is_room_registered(pos) && get_room(pos)[1] != Room.Biome.NULL

func is_room_empty(pos: Vector2) -> bool:
	return (! is_room_registered(pos)) || get_room(pos)[0] == Room.Biome.NULL

func _on_screen_camera_camera_moved(to):
	var biomes = get_room(to)
	if biomes[0] == Room.Biome.NULL:
		await get_tree().process_frame
		biomes = get_room(to)
	
	#if biomes[0] == Room.Biome.NULL:
		#assert(false, "Room not registered")

	emit_signal("room_entered", biomes[0], biomes[1])


func _on_room_entered(biome1 : Room.Biome, biome2 : Room.Biome) -> void:
	if biome1 == Room.Biome.DESERT || biome2 == Room.Biome.DESERT:
		UI.enable_sand_storm()
	else:
		UI.disable_sand_storm()
	if biome1 == Room.Biome.ICE || biome2 == Room.Biome.ICE:
		print("You just entered an icy zone. Brrrrrrr")
		print(Camera.get_children())
		Camera.get_child(0).enable()
	else:
		Camera.get_child(0).disable()
	if biome1 == Room.Biome.MOON || biome2 == Room.Biome.MOON:
		print("Houston, you just entered an moony zone. ")
		Player.suffocate()
	else:
		Player.breathe()
		
