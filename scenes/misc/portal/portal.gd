extends collectible

signal portal_activated(pos:Vector2, biome:Room.Biome, sub_room_type:Room.SubRoomType)

var biome : Room.Biome
var sub_room_type : Room.SubRoomType
var pos : Vector2


func _on_collected():
	emit_signal("portal_activated", pos, biome, sub_room_type)
