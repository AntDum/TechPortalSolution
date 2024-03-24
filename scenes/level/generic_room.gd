extends Node2D



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

@export_group("Item")
@export_subgroup("Portal")
@export var portal : PackedScene
@export var generator : PackedScene

@export_subgroup("Collectible")
@export var wrench : PackedScene
@export var portalite : PackedScene
@export var probability_spawn_item : float = 0.2

var wrench_is_spawned = false
var portalite_is_spawned = false

@onready var screen_size = get_viewport_rect().size
@onready var game_manager = %GameManager

@onready var background_child = $Background
@onready var platform_child = $Platforms

func place_rooms(pos: Vector2, biome: Room.Biome, ignore: Room.SubRoomType, first_map : bool, is_final : bool, can_spawn_items : bool) -> void:
	print("Placing room at ", pos, " ignore ", ignore, " in biome ", biome, " first map ", first_map)
	
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
	background_child.add_child(background_sprite)

	var placed_portal = {}

	for x in range(2):
		for y in range(2):			
			var room_packed: PackedScene
			var sub_type : Room.SubRoomType
			if x == 0 && y == 0:
				room_packed = A1
				sub_type = Room.SubRoomType.I
			elif x == 1 && y == 0:
				room_packed = B2
				sub_type = Room.SubRoomType.II
			elif x == 0 && y == 1:
				room_packed = B1
				sub_type = Room.SubRoomType.III
			elif x == 1 && y == 1:
				room_packed = A2
				sub_type = Room.SubRoomType.IV

			var new_pos = (pos + Vector2(x, y))

			game_manager.register_room(new_pos, biome)
			print("Room contains ", game_manager.get_room(new_pos))
	
			if game_manager.is_room_full(new_pos) || \
				(ignore == sub_type && not first_map):
				continue
			
			var room = room_packed.instantiate()
			room.position = new_pos * screen_size
			platform_child.add_child(room)
			print("Placed room at ", new_pos, " ignore ", ignore, " in biome ", biome, " type ", sub_type)

			
			var portal_points = get_tree().get_nodes_in_group("Portail_point")
			for portal_point in portal_points:
				var portal_position = portal_point.global_position
				if placed_portal.has(portal_position):
					continue
				portal_point.queue_free()
				placed_portal[portal_position] = true
				if game_manager.is_room_full(new_pos) || \
					ignore == sub_type:
					continue

				elif randf() < probability_spawn_item && can_spawn_items:
					print("Spawning item at ", portal_position)
					if randf() < 0.5:
						var wrench_instance = wrench.instantiate()
						room.add_child(wrench_instance)
						wrench_instance.global_position = portal_position
						wrench_is_spawned = true
						wrench_instance.connect("collected", game_manager._on_wrench_collected)
					else:
						var portalite_instance = portalite.instantiate()
						room.add_child(portalite_instance)
						portalite_instance.global_position = portal_position
						portalite_is_spawned = true
						portalite_instance.connect("collected", game_manager._on_portalite_collected)

				elif is_final && portalite_is_spawned && wrench_is_spawned && \
					randf() < probability_spawn_item:
					print("Spawning generator at ", portal_position)
					var generator_instance = generator.instantiate()
					room.add_child(generator_instance)
					generator_instance.game_manager = game_manager
					generator_instance.global_position = portal_position
					generator_instance.connect("repaired", game_manager._on_generator_collected)


				else:
					print("Spawning portal at ", portal_position)
					var portal_instance = portal.instantiate()
					room.add_child(portal_instance)
					portal_instance.global_position = portal_position
					portal_instance.biome = biome
					portal_instance.sub_room_type = sub_type
					portal_instance.room_pos = new_pos
					portal_instance.connect("portal_activated", game_manager.portal_entered)
