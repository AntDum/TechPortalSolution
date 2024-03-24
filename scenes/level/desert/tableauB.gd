extends Node2D


func openGatesUR():
	if($GatesUR != null):
		$GatesUR.queue_free()

func openGatesDL():
	if($GatesDL != null):
		$GatesDL.queue_free()
