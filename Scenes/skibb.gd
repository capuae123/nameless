extends Area2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D  # Reference to the AudioStreamPlayer2D node
@export var target_body_name: String = "Player"  # Name of the target body (e.g., "Player")

func _ready():
	# Connect the body_entered signal using a Callable
	self.body_entered.connect(_on_area2d_body_entered)

func _on_area2d_body_entered(body: Node):
	if body.name == target_body_name:
		if audio_player and not audio_player.playing:  # Check if the audio is not already playing
			audio_player.play()
