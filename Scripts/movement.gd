extends CharacterBody2D

const SPEED = 400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Get input direction
	var input_vector = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	# Normalize the input vector to maintain consistent speed
	input_vector = input_vector.normalized()
	
	# Set velocity based on input
	velocity = input_vector * SPEED
	
	# Play animations based on movement
	if velocity.length() > 0:
		sprite_2d.animation = "running"
		sprite_2d.flip_h = velocity.x < 0
	else:
		sprite_2d.animation = "default"
	
	# Move the character
	move_and_slide()
