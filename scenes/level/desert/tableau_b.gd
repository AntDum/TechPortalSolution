extends Node2D


func openGatesUL():
	pass

func openGatesDR():
	pass

func openGatesDL():
	$TableauB.openGatesDL()
	
func openGatesUR():
	$TableauB.openGatesUR()

func openAllGates(pos: Vector2, biome :Room.Biome, sub_room_type: Room.SubRoomType):
	$TableauB.openGatesDL()
	$TableauB.openGatesUR()
