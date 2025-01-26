extends Node2D

@onready var desert_tilemap: TileMap = $Desert  # Desert terrain
@onready var forest_tilemap: TileMap = $Forest  # Forest terrain
@onready var arctic_tilemap: TileMap = $Arctic  # Arctic terrain

@export var change_speed: float = 0.05  # Time interval between tile changes
var active_tilemap: TileMap
var target_tilemap: TileMap
var is_changing: bool = false

func _ready() -> void:
	# Set the initial terrain to Desert
	active_tilemap = desert_tilemap
	forest_tilemap.visible = false
	arctic_tilemap.visible = false

	# Connect to the temperature_changed signal from the bubble script
	var bubble_node = $Bubble  # Adjust this path to your bubble node
	if bubble_node:
		bubble_node.connect("temperature_changed", Callable(self, "_on_temperature_changed"))
	

func _on_temperature_changed(new_temp: int) -> void:
	# Determine the target terrain based on temperature
	if new_temp > 0:
		target_tilemap = desert_tilemap
	elif new_temp < 0:
		target_tilemap = arctic_tilemap
	else:
		target_tilemap = forest_tilemap

	# Start the terrain change
	start_terrain_change()

func start_terrain_change() -> void:
	if is_changing or active_tilemap == target_tilemap:
		return  # Skip if already changing or if the target is the same as the active terrain

	is_changing = true
	_change_terrain()  # Start terrain change coroutine

func _change_terrain() -> void:
	# Get all tile positions in the active TileMap
	var tile_positions = get_all_tile_positions(active_tilemap)

	while tile_positions.size() > 0:
		# Randomly select a tile to change
		var random_index = randi() % tile_positions.size()
		var pos = tile_positions[random_index]
		tile_positions.remove_at(random_index)

		# Set the tile at the same position to match the target terrain
		var target_tile_id = target_tilemap.get_cell_source_id(0, pos)
		active_tilemap.set_cell(0, pos, target_tile_id)

		# Wait for the specified interval
		await get_tree().create_timer(change_speed).timeout

	# Mark the terrain change as complete
	active_tilemap = target_tilemap
	is_changing = false

func get_all_tile_positions(tilemap: TileMap) -> Array:
	var positions = []
	var used_rect = tilemap.get_used_rect()

	for x in range(used_rect.position.x, used_rect.end.x):
		for y in range(used_rect.position.y, used_rect.end.y):
			var pos = Vector2i(x, y)
			if tilemap.get_cell_source_id(0, pos) != -1:
				positions.append(pos)
	return positions
