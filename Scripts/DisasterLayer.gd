extends CanvasLayer

@export var disaster_images: Array = ["res://Assets/Disasters/Hailstorm art.png", "res://Assets/Disasters/Sandstorm art.png", "res://Assets/Disasters/Tornados.png"]
@export var disaster_duration: float = 3.0
@export var disaster_interval: float = 10.0

var current_disaster_index: int = 0

func _ready():
	if disaster_images.is_empty():
		push_error("No disaster images set in the 'disaster_images' array!")
		return
	show_next_disaster()

func show_next_disaster():
	var disaster_panel = $DisasterPanel
	var texture = load(disaster_images[current_disaster_index])

	if texture == null:
		push_error("Failed to load texture: " + disaster_images[current_disaster_index])
		return

	# Create a StyleBoxTexture and assign it to the Panel
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = texture
	disaster_panel.add_theme_stylebox_override("panel", stylebox)

	disaster_panel.visible = true

	# Adjust temperature based on the disaster type
	if current_disaster_index == 0:  # Hailstorm
		for i in range(20):  # Call cold_bubble() 20 times
			GameData.cold_bubble()
	elif current_disaster_index == 1:  # Sandstorm
		for i in range(20):  # Call hot_bubble() 20 times
			GameData.hot_bubble()
	# Do nothing for Tornados (current_disaster_index == 2)

	await get_tree().create_timer(disaster_duration).timeout
	disaster_panel.visible = false

	# Move to the next disaster
	current_disaster_index = (current_disaster_index + 1) % disaster_images.size()
	await get_tree().create_timer(disaster_interval - disaster_duration).timeout
	show_next_disaster()
