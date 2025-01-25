extends CharacterBody2D

# Movement variables
@export var speed: float = 200.0

# Preload the bubble scenes
@export var hot_bubble_scene: PackedScene
@export var cold_bubble_scene: PackedScene

# Reference to the gun's tip (Marker2D)
@onready var gun_tip = $gun/Tip
@onready var data = $"/root/GameData"

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
