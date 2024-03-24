extends collectible

@onready var collect_item_fx = preload("res://assets/Sound/Sound_effect/Game/Bruit_Item.wav")

func _on_collected():
	animator.play("collected")
	AudioPlayer.play_fx(collect_item_fx)
