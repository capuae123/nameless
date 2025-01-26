extends CharacterBody2D

const SPEED = 120.0  # Movement speed of the player
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@export var hot_bubble_scene: PackedScene
@export var cold_bubble_scene: PackedScene
@export var lightning_scene: PackedScene
var combined_keys_timer: float = 0.0
@export var required_hold_time: float = 2.0

# Reference to the gun's tip (Marker2D)
@onready var gun_tip = $gun/Tip
@onready var data = $"/root/GameData"

func _physics_process(delta: float) -> void:
	# Get input direction from keyboard actions
	var input_vector = Vector2(
		Input.get_axis("move_left", "move_right"),  # Horizontal input (A/D or Left/Right)
		Input.get_axis("move_up", "move_down")  # Vertical input (W/S or Up/Down)
	)

	# Normalize the input vector to ensure consistent speed when moving diagonally
	input_vector = input_vector.normalized()

	# Set the velocity based on input and speed
	velocity = input_vector * SPEED

	# Check if there is input to determine the current animation
	if input_vector != Vector2.ZERO:
		# If horizontal movement is dominant (e.g., moving left or right)
		if abs(input_vector.x) > abs(input_vector.y):
			sprite_2d.animation = "front_right"  # Set the animation to "right"
			sprite_2d.flip_h = input_vector.x > 0  # Flip the sprite when moving left

		# If moving upward (W or Up key pressed)
		elif input_vector.y < 0:
			sprite_2d.animation = "back_idle"  # Set the animation to "back"
			sprite_2d.flip_h = false  # Ensure sprite isn't flipped vertically

		# If moving downward (S or Down key pressed)
		elif input_vector.y > 0:
			sprite_2d.animation = "front_idle"  # Set the animation to "front"
			sprite_2d.flip_h = false  # Ensure sprite isn't flipped vertically

		# Start playing the animation if it's not already playing
		if not sprite_2d.is_playing():
			sprite_2d.play()
	else:
		# No input detected: switch to the "idle" animation
		sprite_2d.animation = "front_idle"  # Set the animation to "idle"
		
		# Play the idle animation only if it's not already playing
		if not sprite_2d.is_playing():
			sprite_2d.play()

	# Move the character based on the calculated velocity
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
