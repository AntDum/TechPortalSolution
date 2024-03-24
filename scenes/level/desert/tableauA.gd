extends Node2D


func openGatesUL():
	if($GatesUL != null):
		$GatesUL.queue_free()

func openGatesDR():
	if($GatesDR != null):
		$GatesDR.queue_free()
