extends Node2D

@export var speed : int = 750

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += Vector2(0,1) * speed * delta


func _on_area_2d_body_entered(body):
	print("Ice on me")
	if body.name == "Player":
		body.get_killed()
