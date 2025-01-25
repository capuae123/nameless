extends CharacterBody2D

@export var Acceleration = 1000
@export var Max_Speed = 300
@export var Friction = 80
@export var MAX_HEALTH = 10

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wander_controller: Node = $wander_control
@onready var player_detection_zone: Area2D = $PlayerDetectionZone

enum {IDLE, WANDER, CHASE}

var state=IDLE
var knockback = Vector2.ZERO
var health = MAX_HEALTH
var enemy_dmg = 1	# Damage done by this enemy


func _physics_process(delta: float) -> void:
	# Motion smoothing
	knockback = knockback.move_toward(Vector2.ZERO,Friction * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	print("Line 26 ",state)
	match state:
		IDLE:
			'''
			Enemy does not move (is idle). 
			seek_player(): checks if player is in visible/identifyable range. 
			wander_controller.tscn: Once timer for state goes off, new state is randomly selected 
									and timer is started.
			'''
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, Friction)
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				print("New State = ", state)
				wander_controller.start_wander_timer(randf_range(1,3))
		
		WANDER:
			'''
			Enemy moves to a randomized point within its specified range. 
			seek_player(): checks if player is in visible/identifyable range. 
			wander_controller.tscn: Once timer for state goes off, new state is randomly selected 
									and timer is started.
			wander_controller randomly selects a point within range and enemy move_toward() it.
			'''
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				print("New State = ", state)
				wander_controller.start_wander_timer(randf_range(1,3))
			var direction = global_position.direction_to(wander_controller.target_pos)
			velocity = velocity.move_toward(Max_Speed * direction, Acceleration * delta)
			if global_position.distance_to(wander_controller.target_pos) <= 4:
				state = pick_random_state([IDLE,WANDER])
				wander_controller.start_wander_timer(randf_range(1,3))
			sprite.flip_h = velocity.x < 0
		
		CHASE:
			'''
			Enemy follows/chases player as long as player is in detectable range.
			Killzone scene sends a signal when a body enters it.
			wander_controller.tscn: Once timer for state goes off, new state is randomly selected 
									and timer is started.
			'''
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(Max_Speed * direction, Acceleration * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity


func seek_player():
	if player_detection_zone.can_see_player():
		print("CAN SEE PLAYER!!!!!!")
		sprite.play("attac")
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func take_dmg(dmg):
	health -= dmg
	print("Enemy health.........", health )
