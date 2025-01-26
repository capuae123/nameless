extends CharacterBody2D

var obj = "Enemy"

@export var Acceleration = 1000
@export var Max_Speed = 500
@export var Friction = 30
@export var MAX_HEALTH = 10
@export var dmg = 1

# Random animation selector
@onready var idle = ["idle_NE","idle_NW","idle_SE","idle_SW"][randi() % ["idle_NE","idle_NW","idle_SE","idle_SW"].size()]

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
@onready var stats = $stats

enum {IDLE, CHASE, ATTACK}

var state = IDLE
var knockback = Vector2.ZERO
var health = MAX_HEALTH
var enemy_dmg = 1  # Damage done by this enemy

# Maps movement direction to animation names
var animation_map = {
	"up_right": "run_NE",
	"up_left": "run_NW",
	"down_right": "run_SE",
	"down_left": "run_SW",
	"idle_up_right": "idle_NE",
	"idle_up_left": "idle_NW",
	"idle_down_right": "idle_SE",
	"idle_down_left": "idle_SW",
}

func _physics_process(delta: float) -> void:
	# Motion smoothing
	knockback = knockback.move_toward(Vector2.ZERO, Friction * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity

	match state:
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, Friction)
			sprite.play(animation_for_direction(Vector2.ZERO))

		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(Max_Speed * direction, Acceleration * delta)
				sprite.play(animation_for_direction(direction))
			else:
				state = IDLE 
		
		ATTACK:
			pass

	set_velocity(velocity)
	move_and_slide()
	velocity = velocity


func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE


func animation_for_direction(direction: Vector2) -> String:
	if direction == Vector2.ZERO:
		# Return idle animation when not moving
		return animation_map["idle_down_right"]  # Default idle animation

	# Determine direction based on angle and components
	if direction.x > 0 and direction.y > 0:
		return animation_map["down_right"]
	elif direction.x < 0 and direction.y > 0:
		return animation_map["down_left"]
	elif direction.x > 0 and direction.y < 0:
		return animation_map["up_right"]
	elif direction.x < 0 and direction.y < 0:
		return animation_map["up_left"]
	else:
		# Default fallback (optional, but ensures all paths return a value)
		return animation_map["idle_down_right"]


func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		sprite.play("death_SE")
		get_tree().change_scene_to_file("res://Scenes/desertlayout.tscn")
	print("Enemy health.........", health )
