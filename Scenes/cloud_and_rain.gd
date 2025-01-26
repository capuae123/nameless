extends Node2D

@onready var cloud = $AnimatedSprite2D
@onready var camera = $"../Camera2D" # Assuming Camera2D is the direct sibling of Rain

# Cloud movement settings
var speed: float = 100.0 # Speed of the cloud moving along the x-axis
var loop_distance: float = 500.0 # Distance after which the cloud loops back

func _ready():
	# Set the cloud's initial position relative to the camera
	cloud.position = Vector2(camera.position.x, camera.position.y - 100) # Adjust Y-offset as needed

func _process(delta: float) -> void:
	# Keep the cloud fixed relative to the camera on the Y-axis
	cloud.position.y = camera.position.y - 100

	# Move the cloud in the X-axis
	cloud.position.x += speed * delta

	# Loop the cloud back if it exceeds the loop distance
	if cloud.position.x > camera.position.x + loop_distance:
		cloud.position.x = camera.position.x - loop_distance
