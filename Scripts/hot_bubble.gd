extends Node2D

@export var speed: float = 100.0
@export var burst_scene: PackedScene  # Drag and drop the burst.tscn here in the Inspector
@export var burst_time: float = 0.5  # Time in seconds for the bubble to burst

@export var randomness_factor: float = 150.0  # Controls the sway speed
var random_direction: float = 1.0  # Random direction for X-axis movement
var sway_duration: float = 0.2  # Time in seconds for the sway to happen
var sway_timer: float = 0.1  # Timer to track the swaying duration

func _ready():
	# Start a timer to burst after `burst_time` seconds
	await get_tree().create_timer(burst_time).timeout
	spawn_burst()

	# Random initial direction (left or right)
	random_direction = randf_range(-randomness_factor, randomness_factor)

func _process(delta: float):
	# Move the bubble upwards on the Y-axis (positive Y direction)
	position.y -= speed * delta

	# Check if Q or E is pressed to start the horizontal sway
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		# If sway duration hasn't passed yet, start swaying
		if sway_timer < sway_duration:
			# Start the horizontal sway
			position.x += random_direction * delta  # This moves the bubble left or right
			sway_timer += delta  # Increase the timer
		else:
			# After 0.2 seconds, stop swaying
			position.x += 0  # Maintain position and stop further movement
			sway_timer = 0  # Reset the timer after swaying

func spawn_burst():
	if burst_scene:
		# Create a burst instance
		var burst_instance = burst_scene.instantiate()
		# Position it where the bubble bursts
		burst_instance.position = position
		# Add it to the current scene
		get_tree().current_scene.add_child(burst_instance)

	# Free the bubble node
	queue_free()
