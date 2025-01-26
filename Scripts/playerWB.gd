extends CharacterBody2D

# Movement variables
@export var speed: float = 200.0

# Preload the bubble scenes
@export var hot_bubble_scene: PackedScene
@export var cold_bubble_scene: PackedScene
@export var lightning_scene: PackedScene
var combined_keys_timer: float = 0.0
@export var required_hold_time: float = 2.0
@export var bubble_cooldown: float = 0.3  # Cooldown time between bubbles in seconds
var can_spawn_bubble: bool = true  # Prevent spamming

# Reference to the gun's tip (Marker2D)
@onready var gun_tip = $gun/Tip
@onready var data = $"/root/GameData"
@onready var timer = $Timer

func get_input() -> Vector2:
	# Gather input and normalize for smooth diagonal movement
	var input_vector = Vector2(
		Input.get_axis(("move_left"), ("move_right")),
		Input.get_axis(("move_up"), ("move_down"))
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

	# Move the character
	move_and_slide()

	# Check if both keys are pressed
	if Input.is_action_pressed("spawn_hot_bubble") and Input.is_action_pressed("spawn_cold_bubble"):
		# Increment the timer if both keys are pressed
		combined_keys_timer += delta
		# If held long enough, spawn electric bubble
		if combined_keys_timer >= required_hold_time and can_spawn_bubble:
			spawn_bubble(lightning_scene)
			data.electric_bubbles()  # Custom logic for electric bubble (if needed)
			start_bubble_cooldown()  # Start cooldown
			combined_keys_timer = 0.0  # Reset the timer after spawning
	else:
		# Reset the timer if either key is released
		combined_keys_timer = 0.0

	# Handle bubble spawning
	if Input.is_action_just_pressed("spawn_hot_bubble") and can_spawn_bubble:
		spawn_bubble(hot_bubble_scene)
		data.hot_bubble()
		start_bubble_cooldown()  # Start cooldown
	elif Input.is_action_just_pressed("spawn_cold_bubble") and can_spawn_bubble:
		spawn_bubble(cold_bubble_scene)
		data.cold_bubble()
		start_bubble_cooldown()  # Start cooldown

func spawn_bubble(bubble_scene: PackedScene):
	if bubble_scene:
		# Create a new instance of the bubble
		var bubble_instance = bubble_scene.instantiate()
		# Set its position to the gun tip
		bubble_instance.position = gun_tip.global_position
		# Add it to the current scene
		get_tree().current_scene.add_child(bubble_instance)

func start_bubble_cooldown():
	# Disable bubble spawning and start the timer
	can_spawn_bubble = false
	timer.wait_time = bubble_cooldown
	timer.start()

func _on_timer_timeout() -> void:
	# Re-enable bubble spawning after cooldown
	can_spawn_bubble = true
	data.add_energy()
