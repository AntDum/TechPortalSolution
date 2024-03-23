class_name Room

# Room placement
#   I  |  II
#  III |  IV

enum SubRoomType {
	I,
	II,
	III,
	IV,
}

enum Biome {
	DESERT,
	ICE,
	LUNE,
	NULL
}

static func get_position_subroom(from: Vector2, sub_room_type: SubRoomType, wanted: SubRoomType) -> Vector2:
	var offset : Vector2
	if sub_room_type == SubRoomType.I:
		if wanted == SubRoomType.I:
			offset = Vector2(-1, -1)
		elif wanted == SubRoomType.II:
			offset = Vector2(0, -1)
		elif wanted == SubRoomType.III:
			offset = Vector2(-1, 0)
		elif wanted == SubRoomType.IV:
			offset = Vector2(0, 0)
	elif sub_room_type == SubRoomType.II:
		if wanted == SubRoomType.I:
			offset = Vector2(0, -1)
		elif wanted == SubRoomType.II:
			offset = Vector2(1, -1)
		elif wanted == SubRoomType.III:
			offset = Vector2(0, 0)
		elif wanted == SubRoomType.IV:
			offset = Vector2(1, 0)
	elif sub_room_type == SubRoomType.III:
		if wanted == SubRoomType.I:
			offset = Vector2(-1, 0)
		elif wanted == SubRoomType.II:
			offset = Vector2(0, 0)
		elif wanted == SubRoomType.III:
			offset = Vector2(-1, 1)
		elif wanted == SubRoomType.IV:
			offset = Vector2(0, 1)
	elif sub_room_type == SubRoomType.IV:
		if wanted == SubRoomType.I:
			offset = Vector2(0, 0)
		elif wanted == SubRoomType.II:
			offset = Vector2(1, 0)
		elif wanted == SubRoomType.III:
			offset = Vector2(0, 1)
		elif wanted == SubRoomType.IV:
			offset = Vector2(1, 1)
	return from + offset

static func get_random_biome(exclude: Room.Biome):
	var biomes = Room.Biome.values()
	biomes.erase(exclude)
	return biomes[randi() % biomes.size()]



static func test_get_position_subroom():
	var from = Vector2(0, 0)
	var sub_room_type = SubRoomType.I
	var wanted = SubRoomType.II

	var result = get_position_subroom(from, sub_room_type, wanted)
	assert(result == Vector2(0, -1), "Test case 1 failed")

	from = Vector2(0, 0)
	sub_room_type = SubRoomType.I
	wanted = SubRoomType.III

	result = get_position_subroom(from, sub_room_type, wanted)
	assert(result == Vector2(-1, 0), "Test case 2 failed")

	from = Vector2(0, 0)
	sub_room_type = SubRoomType.II
	wanted = SubRoomType.I

	result = get_position_subroom(from, sub_room_type, wanted)
	assert(result == Vector2(0, -1), "Test case 3 failed")

	from = Vector2(0, 0)
	sub_room_type = SubRoomType.II
	wanted = SubRoomType.III

	result = get_position_subroom(from, sub_room_type, wanted)
	assert(result == Vector2(0, 0), "Test case 4 failed")

	from = Vector2(0, 0)
	sub_room_type = SubRoomType.III
	wanted = SubRoomType.I

	result = get_position_subroom(from, sub_room_type, wanted)
	assert(result == Vector2(-1, 0), "Test case 5 failed")

	from = Vector2(0, 0)
	sub_room_type = SubRoomType.III
	wanted = SubRoomType.II

	result = get_position_subroom(from, sub_room_type, wanted)
	assert(result == Vector2(0, 0), "Test case 6 failed")

	print("All test cases passed")
