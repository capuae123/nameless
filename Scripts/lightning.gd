extends Node2D

var obj = "Attack"

@export var speed: float = 100.0
@export var burst_scene: PackedScene  # Drag and drop the burst.tscn here in the Inspector
@export var burst_time: float = 2.0  # Time in seconds for the bubble to burst
@export var dmg = 3

@onready var collider = $Area2D/CollisionShape2D

func _ready():
	# Start a timer to burst after `burst_time` seconds
	await get_tree().create_timer(burst_time).timeout
	spawn_burst()

func _process(delta: float):
	position.x -= speed * delta
	if position.y < -100:  # Adjust this value based on your game boundary
		spawn_burst()
		queue_free()  # Remove the bubble

func spawn_burst():
	if burst_scene:
		# Create a burst instance
		var burst_instance = burst_scene.instantiate()
		# Position it where the bubble bursts
		burst_instance.position = position
		# Add it to the current scene
		get_tree().current_scene.add_child(burst_instance)

	# Free the bubble node
	queue_free()



#func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("test")
