extends Node2D


@export var iceSpike : PackedScene

@export var mean_time_bt_spikes : float = .6


func _ready():
	$RandomCooldown.start(abs(randfn(0,mean_time_bt_spikes)))

func _on_random_cooldown_timeout():
	var iceSpikeInstance = iceSpike.instantiate()
	iceSpikeInstance.position = Vector2(1,0) * randi_range(100,1820)
	add_child(iceSpikeInstance)
	$RandomCooldown.start(abs(randfn(0,mean_time_bt_spikes)))
