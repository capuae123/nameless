extends CharacterBody2D

var obj = "Player"

# Movement & HP variables
@export var speed: float = 200.0
@export var MAX_HEALTH = 5  # Now it's 5 for health bars
var health = MAX_HEALTH

# Health bar images
@export var health_bar_images: Array[Texture2D]  # Add these in the Inspector
@onready var health_bar_sprite = $HealthBar/Sprite2D

# Boar interaction
var is_in_contact_with_boar = false
var boar_damage_timer: float = 2.0  # Time between damage
var boar_damage_cooldown: float = 0.0  # Timer for damage cooldown

# Gun & bubble mechanics
@export var hot_bubble_scene: PackedScene
@export var cold_bubble_scene: PackedScene
@export var lightning_scene: PackedScene
var combined_keys_timer: float = 0.0
@export var required_hold_time: float = 2.0
@export var bubble_cooldown: float = 0.3  # Cooldown time between bubbles in seconds
var can_spawn_bubble: bool = true  # Prevent spamming

@onready var gun_tip = $gun/Tip
@onready var data = $"/root/GameData"
@onready var timer = $Timer

func get_input() -> Vector2:
	var input_vector = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	return input_vector.normalized()

func _physics_process(delta: float) -> void:
	var input_direction = get_input()

	velocity = Vector2(
		input_direction.x * speed,
		input_direction.y * speed / 2
	)

	move_and_slide()

	# Handle combined keys for bubble spawning
	if Input.is_action_pressed("spawn_hot_bubble") and Input.is_action_pressed("spawn_cold_bubble"):
		combined_keys_timer += delta
		if combined_keys_timer >= required_hold_time:
			spawn_bubble(lightning_scene)
			data.electric_bubbles()
			combined_keys_timer = 0.0
	else:
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

	# Handle boar damage
	if is_in_contact_with_boar:
		boar_damage_cooldown -= delta
		if boar_damage_cooldown <= 0:
			take_dmg(1)  # Reduce health by 1
			boar_damage_cooldown = boar_damage_timer  # Reset the cooldown

func spawn_bubble(bubble_scene: PackedScene):
	if bubble_scene:
		var bubble_instance = bubble_scene.instantiate()
		bubble_instance.position = gun_tip.global_position
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

# Update health and health bar
func take_dmg(dmg):
	health -= dmg
	health = max(health, 0)  # Prevent negative health
	update_health_bar()
	print("Player health:", health)

func update_health_bar():
	if health >= 0 and health < health_bar_images.size():
		health_bar_sprite.texture = health_bar_images[health]

# Trigger contact with boar
func start_boar_damage():
	is_in_contact_with_boar = true
	boar_damage_cooldown = boar_damage_timer

func stop_boar_damage():
	is_in_contact_with_boar = false
