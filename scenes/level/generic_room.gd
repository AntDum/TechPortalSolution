extends Node2D

@export var portal : PackedScene
@export var probability_spawn_portal : float = 1.0

@export_group("Desert")
@export var desert_A : Array[PackedScene]
@export var desert_B : Array[PackedScene]
@export var desert_background : Texture

@export_group("Ice")
@export var ice_A : Array[PackedScene]
@export var ice_B : Array[PackedScene]
@export var ice_background : Texture

@export_group("Moon")
@export var moon_A : Array[PackedScene]
@export var moon_B : Array[PackedScene]
@export var moon_background : Texture

@onready var screen_size = get_viewport_rect().size
@onready var game_manager = %GameManager

func place_room(pos: Vector2, biome: Room.Biome, from: Room.SubRoomType) -> void:
	var A_bag
	var B_bag
	var background

	match biome:
		Room.Biome.DESERT:
			A_bag = desert_A
			B_bag = desert_B
			background = desert_background
		Room.Biome.ICE:
			A_bag = ice_A
			B_bag = ice_B
			background = ice_background
		Room.Biome.MOON:
			A_bag = moon_A
			B_bag = moon_B
			background = moon_background

	# Choose two A rooms and two B rooms
	var A1 : PackedScene = A_bag[randi() % A_bag.size()]
	var A2 : PackedScene = A_bag[randi() % A_bag.size()]
	var B1 : PackedScene = B_bag[randi() % B_bag.size()]
	var B2 : PackedScene = B_bag[randi() % B_bag.size()]

	# Room placement
	# A1 | B1
	# B2 | A2

	var background_sprite = Sprite2D.new()
	background_sprite.texture = background
	background_sprite.offset = screen_size
	add_child(background_sprite)

	for i in range(2):
		for j in range(2):



			var room_packed: PackedScene
			var sub_type : Room.SubRoomType
			if i == 0 && j == 0:
				if from == Room.SubRoomType.IV:
					continue
				room_packed = A1
				sub_type = Room.SubRoomType.I
			elif i == 0 && j == 1:
				if from == Room.SubRoomType.III:
					continue
				room_packed = B1
				sub_type = Room.SubRoomType.II
			elif i == 1 && j == 0:
				if from == Room.SubRoomType.I:
					continue
				room_packed = A2
				sub_type = Room.SubRoomType.III
			else:
				if from == Room.SubRoomType.II:
					continue
				room_packed = B2
				sub_type = Room.SubRoomType.IV
			var room = room_packed.instantiate()
			var new_pos = (pos + Vector2(j, i))
			room.position = new_pos * screen_size
			add_child(room)

			game_manager.register_room(new_pos, biome)
			
			var portal_points = get_tree().get_nodes_in_group("Portail_point")
			for portal_point in portal_points:
				if randf() < probability_spawn_portal:
					var portal_instance = portal.instantiate()
					portal_instance.global_position = portal_point.global_position
					room.add_child(portal_instance)
					portal_instance.biome = biome
					portal_instance.sub_room_type = sub_type
					portal_instance.pos = pos
					portal_instance.connect("portal_activated", game_manager.portal_entered)
				portal_point.queue_free()
