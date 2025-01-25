extends Node2D

@export var speed: float = 100.0

func _process(delta: float):
	# Move the bubble upwards
	position.y -= speed * delta
	if position.y < -100:  # Adjust based on your game boundary
		queue_free()  # Remove the bubble when it moves off-screen
