extends CharacterBody2D

const SPEED = 120.0  # Movement speed of the player
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@onready var walking_sound: AudioStreamPlayer2D = $WalkingSound  # Reference to the walking sound node
@onready var bubble_sound: AudioStreamPlayer2D = $BubbleSound  # Reference to the bubble sound node
@export var hot_bubble_scene: PackedScene
@export var cold_bubble_scene: PackedScene
@export var lightning_scene: PackedScene
@export var bubble_cooldown: float = 0.3  # Cooldown time between bubbles in seconds
var can_spawn_bubble: bool = true  # Prevent spamming
var combined_keys_timer: float = 0.0
@export var required_hold_time: float = 2.0

@export var MAX_HEALTH = 5  # Now it's 5 for health bars
var health = MAX_HEALTH

# Reference to the gun's tip (Marker2D)
@onready var gun_tip = $gun/Tip
@onready var data = $"/root/GameData"
@onready var timer = $Timer

var is_in_contact_with_boar = false
var boar_damage_timer: float = 2.0  # Time between damage
var boar_damage_cooldown: float = 0.0  # Timer for damage cooldown

# Health bar images
@export var health_bar_images: Array[Texture2D]  # Add these in the Inspector
@onready var health_bar_sprite = $HealthBar/Sprite2D

func _physics_process(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	input_vector = input_vector.normalized()
	velocity = input_vector * SPEED

	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			sprite_2d.animation = "front_right"
			sprite_2d.flip_h = input_vector.x > 0
		elif input_vector.y < 0:
			sprite_2d.animation = "back_idle"
			sprite_2d.flip_h = false
		elif input_vector.y > 0:
			sprite_2d.animation = "front_idle"
			sprite_2d.flip_h = false

		if not sprite_2d.is_playing():
			sprite_2d.play()

		if not walking_sound.playing:
			walking_sound.play()
	else:
		if walking_sound.playing:
			walking_sound.stop()

		sprite_2d.animation = "front_idle"
		if not sprite_2d.is_playing():
			sprite_2d.play()

	move_and_slide()

	if Input.is_action_pressed("spawn_hot_bubble") and Input.is_action_pressed("spawn_cold_bubble"):
		combined_keys_timer += delta
		if combined_keys_timer >= required_hold_time:
			spawn_bubble(lightning_scene)
			data.electric_bubbles()
			combined_keys_timer = 0.0
	else:
		combined_keys_timer = 0.0

	if Input.is_action_just_pressed("spawn_hot_bubble"):
		spawn_bubble(hot_bubble_scene)
		data.hot_bubble()
	elif Input.is_action_just_pressed("spawn_cold_bubble"):
		spawn_bubble(cold_bubble_scene)
		data.cold_bubble()

	if is_in_contact_with_boar:
		boar_damage_cooldown -= delta
		if boar_damage_cooldown <= 0:
			take_dmg(1)
			boar_damage_cooldown = boar_damage_timer

func spawn_bubble(bubble_scene: PackedScene):
	if bubble_scene:
		var bubble_instance = bubble_scene.instantiate()
		bubble_instance.position = gun_tip.global_position
		get_tree().current_scene.add_child(bubble_instance)

		# Play bubble pop sound
		if bubble_sound:
			bubble_sound.play()

func start_bubble_cooldown():
	can_spawn_bubble = false
	timer.wait_time = bubble_cooldown
	timer.start()

func _on_timer_timeout() -> void:
	can_spawn_bubble = true
	data.add_energy()

func take_dmg(dmg):
	health -= dmg
	health = max(health, 0)
	update_health_bar()
	print("Player health:", health)

func update_health_bar():
	if health >= 0 and health < health_bar_images.size():
		health_bar_sprite.texture = health_bar_images[health]

func start_boar_damage():
	is_in_contact_with_boar = true
	boar_damage_cooldown = boar_damage_timer

func stop_boar_damage():
	is_in_contact_with_boar = false
