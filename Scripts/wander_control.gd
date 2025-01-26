extends Node

@export var wander_range = 32

@onready var start_pos = get_parent().global_position
@onready var target_pos = get_parent().global_position
@onready var timer = $Timer


func _ready():
	update_target_position()


func update_target_position():
	var target_vector=Vector2(randf_range(-wander_range,wander_range),randf_range(-wander_range,wander_range))
	target_pos = start_pos + target_vector


func get_time_left():
	return timer.time_left


func start_wander_timer(duration):
	timer.start(duration)



func _on_timer_timeout() -> void:
	update_target_position()
