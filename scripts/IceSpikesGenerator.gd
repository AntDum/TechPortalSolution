extends Node2D


@export var iceSpike : PackedScene


@export var mean_time_bt_spikes : float = .6
@export var deviation_time_bt_spikes : float = .5

func _on_random_cooldown_timeout():
	print("ACHTUNG")
	var iceSpikeInstance = iceSpike.instantiate()
	iceSpikeInstance.position = Vector2(1,0) * randi_range(100,1820)
	add_child(iceSpikeInstance)
	$RandomCooldown.start(abs(randfn(mean_time_bt_spikes,deviation_time_bt_spikes)))

func enable():
	print("Ice falling enabled")
	$RandomCooldown.start(abs(randfn(mean_time_bt_spikes,deviation_time_bt_spikes)))
	
func disable():
	$RandomCooldown.stop()