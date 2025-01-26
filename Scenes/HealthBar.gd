extends CanvasLayer

# Reference to the Sprite node for the health bar
@onready var health_bar_sprite = $Sprite2D  # Get the Sprite2D node in the HealthBar

# Define the health values (starting with full health)
var health = 5  # Full health (5 bars)

# Array of health bar textures (images for health)
var health_textures = [
	preload("res://Assets/health_full.png"),    # Full health (5 bars)
	preload("res://Assets/health_four.png"),    # 4/5 health
	preload("res://Assets/health_three.png"),   # 3/5 health
	preload("res://Assets/health_two.png"),     # 2/5 health
	preload("res://Assets/health_one.png"),     # 1/5 health
	preload("res://Assets/health_empty.png")    # Empty health (0 bars)
]

# Function to update the health bar texture based on health value
func update_health_bar():
	if health >= 0 and health <= 5:
		health_bar_sprite.texture = health_textures[health]
	else:
		print("Error: Health value out of range")

# Call this function whenever the player takes damage
func _on_player_take_damage():
	health -= 1  # Reduce health by 1
	health = max(0, health)  # Ensure health doesn't go below 0
	update_health_bar()  # Update the health bar
