extends CharacterBody2D

@export var Acceleration = 1000
@export var Max_Speed = 300
@export var Friction = 30
@export var MAX_HEALTH = 10
@onready var idle = ["idle_NE","idle_NW","idle_SE","idle_SW"][randi() % ["idle_NE","idle_NW","idle_SE","idle_SW"].size()]

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
@onready var stats = $stats

enum {IDLE, CHASE, ATTACK}

var state = IDLE
var knockback = Vector2.ZERO
var health = MAX_HEALTH
var enemy_dmg = 1	# Damage done by this enemy



func _physics_process(delta: float) -> void:
	# Motion smoothing
	knockback = knockback.move_toward(Vector2.ZERO,Friction * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	
	match state:
		IDLE:
			'''
			Enemy does not move (is idle). 
			seek_player(): checks if player is in visible/identifyable range.
			'''
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, Friction)
			sprite.play(idle)

		CHASE:
			'''
			Enemy follows/chases player as long as player is in detectable range.
			Killzone scene sends a signal when a body enters it.
			'''
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(Max_Speed * direction, Acceleration * delta)
				sprite.play("run_NW")
			else:
				state = IDLE

		ATTACK:
			pass
	
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity


func seek_player():
	if player_detection_zone.can_see_player():
		print("Inside Player detection")
		sprite.play("attac")
		state = CHASE



func take_dmg(dmg):
	health -= dmg
	print("Enemy health.........", health )
