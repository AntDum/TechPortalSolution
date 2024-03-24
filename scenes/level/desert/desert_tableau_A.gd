extends Node2D


func openGatesUL():
	$GatesUL.queue_free()

func openGatesDR():
	$GatesDR.queue_free()
