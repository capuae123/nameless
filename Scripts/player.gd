extends CharacterBody2D

# Movement variables
@export var speed: float = 200.0

func get_input() -> Vector2:
	# Gather input and normalize for smooth diagonal movement
	var input_vector = Vector2(
		 Input.get_axis(("move_left"),("move_right")),
		Input.get_axis(("move_up"),("move_down")),
	)
	
	
	
	return input_vector.normalized()

func _physics_process(delta: float) -> void:
	# Get input direction
	var input_direction = get_input()

	# Adjust movement for isometric perspective
	velocity = Vector2(
		input_direction.x * speed,
		input_direction.y * speed / 2  # Y-axis movement is slower for isometric effect
	)
	print (input_direction)
	

	# Move the character
	move_and_slide()
