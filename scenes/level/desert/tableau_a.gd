extends Node2D


func openGatesUL():
	$TableauA.openGatesUL()

func openGatesDR():
	$TableauA.openGatesDR()

func openGatesDL():
	pass
	
func openGatesUR():
	pass

func openAllGates(pos: Vector2, biome :Room.Biome, sub_room_type: Room.SubRoomType):
	$TableauA.openGatesDR()
	$TableauA.openGatesUL()
