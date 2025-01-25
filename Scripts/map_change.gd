extends Node2D

@export var change_speed: float = 0.05  # Speed of tile transitions (seconds per tile)
@onready var desert_tilemap: TileMap = $Desert  # Desert terrain TileMap
@onready var forest_tilemap: TileMap = $Forest  # Forest terrain TileMap
@onready var arctic_tilemap: TileMap = $Arctic  # Arctic terrain TileMap

var active_tilemap: TileMap = desert_tilemap  # The current active terrain (default: desert)
var target_tilemap: TileMap = null  # The target terrain to transition to
var is_changing: bool = false  # Whether a terrain transition is currently happening

func _ready():
	# Ensure only the active tilemap (desert) is visible at the start
	desert_tilemap.visible = true
	forest_tilemap.visible = false
	arctic_tilemap.visible = false

	# For testing: Trigger a terrain transition (remove this in production)
	# transition_to_terrain("forest")

# Call this function to trigger a terrain change
func transition_to_terrain(terrain: String) -> void:
	if is_changing:
		return  # Prevent multiple transitions at once

	match terrain:
		"desert":
			target_tilemap = desert_tilemap
		"forest":
			target_tilemap = forest_tilemap
		"arctic":
			target_tilemap = arctic_tilemap
		_:
			return  # Invalid terrain name

	# Start the tile-changing process
	is_changing = true
	_change_tiles()

# Coroutine to gradually change the tiles
func _change_tiles() -> void:
	# Get all positions of tiles in the active and target tilemaps
	var active_positions = get_all_tile_positions(active_tilemap)
	while active_positions.size() > 0:
		# Randomly select a tile position
		var random_index = randi() % active_positions.size()
		var pos = active_positions[random_index]
		active_positions.remove_at(random_index)

		# Get the target tile ID at the same position
		var target_tile_id = target_tilemap.get_cell(0, pos)

		# Update the active tilemap with the target tile ID
		active_tilemap.set_cell(0, pos, target_tile_id)

		# Wait before processing the next tile
		await get_tree().create_timer(change_speed).timeout

	# Finalize the terrain change
	is_changing = false
	active_tilemap = target_tilemap
	_update_visibility()

# Make only the active tilemap visible
func _update_visibility() -> void:
	desert_tilemap.visible = (active_tilemap == desert_tilemap)
	forest_tilemap.visible = (active_tilemap == forest_tilemap)
	arctic_tilemap.visible = (active_tilemap == arctic_tilemap)

# Get all tile positions in the given tilemap
func get_all_tile_positions(tilemap: TileMap) -> Array:
	var positions = []
	var used_rect = tilemap.get_used_rect()  # Get the rectangle covering used tiles
	for x in range(used_rect.position.x, used_rect.end.x):
		for y in range(used_rect.position.y, used_rect.end.y):
			var pos = Vector2i(x, y)
			if tilemap.get_cell(0, pos) != -1:  # Check if a tile exists
				positions.append(pos)
	return positions
