extends CharacterBody2D

#const EnemyDeathEffect=preload("res://Game2/Lvl/EnemyDeathEffect.tscn")

@export var Acceleration=300
@export var Max_Speed=150
@export var Friction=200

var knockback=Vector2.ZERO
var state=IDLE

@onready var stats=$Stats
@onready var playerDetectionZone=$PlayerDetectionZone
@onready var sprite=$AnimatedSprite2D
@onready var hurtbox=$HurtBix
@onready var softcollision=$SoftCollision
@onready var wanderController=$WanderController

enum {IDLE,WANDER,CHASE}


func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,200*delta)
	set_velocity(knockback)
	move_and_slide()
	knockback=velocity
	match state:
		IDLE:
			velocity=velocity.move_toward(Vector2.ZERO,Friction)
			seek_player()
			if wanderController.get_time_left()==0:
				state=pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(randf_range(1,3))
	
		WANDER:
			seek_player()
			if wanderController.get_time_left()==0:
				state=pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(randf_range(1,3))
			var direction=global_position.direction_to(wanderController.target_pos)
			velocity=velocity.move_toward(Max_Speed*direction,Acceleration*delta)
			if global_position.distance_to(wanderController.target_pos)<=4:
				state=pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(randf_range(1,3))
			sprite.flip_h=velocity.x<0
	
		CHASE:
			var player=playerDetectionZone.player
			if player!=null:
				var direction=global_position.direction_to(player.global_position)
				velocity=velocity.move_toward(Max_Speed*direction,Acceleration*delta)
			else:
				state=IDLE
			sprite.flip_h=velocity.x<0
	if softcollision.is_colliding():
		velocity+=softcollision.get_push_vector()*50
	set_velocity(velocity)
	move_and_slide()
	velocity=velocity


func seek_player():
	if playerDetectionZone.can_see_player():
		state=CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_HurtBix_area_entered(area: Area2D):
	stats.health-=area.damage
	knockback=area.knockback_direction*120
	hurtbox.create_hit_effect()


func _on_Stats_ded():
	queue_free()
	var enemyDeathEffect=EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position=self.position
