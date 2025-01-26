extends CharacterBody2D

# Movement variables
@export var speed: float = 200.0

# Preload the bubble scenes
@export var hot_bubble_scene: PackedScene
@export var cold_bubble_scene: PackedScene
@export var lightning_scene: PackedScene
var combined_keys_timer: float = 0.0
@export var required_hold_time: float = 2.0

# Reference to the gun's tip (Marker2D)
@onready var gun_tip = $gun/Tip
@onready var data = $"/root/GameData"
@onready var timer =$Timer

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
		if combined_keys_timer >= required_hold_time:
			spawn_bubble(lightning_scene)
			data.electric_bubbles()  # Custom logic for electric bubble (if needed)
			combined_keys_timer = 0.0  # Reset the timer after spawning
	else:
		# Reset the timer if either key is released
		combined_keys_timer = 0.0
	
	# Handle bubble spawning
	if Input.is_action_just_pressed("spawn_hot_bubble"):
		spawn_bubble(hot_bubble_scene)
		data.hot_bubble()
	elif Input.is_action_just_pressed("spawn_cold_bubble"):
		spawn_bubble(cold_bubble_scene)
		data.cold_bubble()

func spawn_bubble(bubble_scene: PackedScene):
	if bubble_scene:
		# Create a new instance of the bubble
		var bubble_instance = bubble_scene.instantiate()
		# Set its position to the gun tip
		bubble_instance.position = gun_tip.global_position
		# Add it to the current scene
		get_tree().current_scene.add_child(bubble_instance)


func _on_timer_timeout() -> void:
	data.add_energy()
