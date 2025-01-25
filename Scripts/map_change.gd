extends Node2D

@export var change_speed: float = 0.1  # Time interval between tile changes (in seconds)
@onready var desert_tilemap: TileMap = $Desert  # TileMap node for Desert terrain
@onready var forest_tilemap: TileMap = $Forest  # TileMap node for Forest terrain
@onready var arctic_tilemap: TileMap = $Arctic  # TileMap node for Arctic terrain

var active_tilemap: TileMap  # The current active terrain's TileMap
var target_tilemap: TileMap  # The target terrain's TileMap
var is_changing: bool = false  # Whether the terrain is currently being changed
var change_task_running: bool = false  # Tracks if a coroutine is running

func _ready() -> void:
	# Set the initial active terrain (Desert in this case)
	active_tilemap = desert_tilemap
	forest_tilemap.visible = false
	arctic_tilemap.visible = false
	print("Terrain system initialized. Active terrain: Desert")

func _process(delta: float) -> void:
	# Check for key inputs to trigger terrain change
	if Input.is_action_just_pressed("change_to_forest") and active_tilemap != forest_tilemap:
		start_terrain_change(forest_tilemap)
	elif Input.is_action_just_pressed("change_to_arctic") and active_tilemap != arctic_tilemap:
		start_terrain_change(arctic_tilemap)

func start_terrain_change(target: TileMap) -> void:
	if active_tilemap == target:
		print("Skipping terrain change: Target is the same as active.")
		return  # Skip if the target is the same as active

	if is_changing:
		print("Interrupting the current terrain change!")
		is_changing = false  # Stop the current process

	# Set up the new change process
	print("Starting terrain change to: ", target.name)
	is_changing = true
	target_tilemap = target
	target_tilemap.visible = true  # Make the target TileMap visible

	# Start the coroutine
	if not change_task_running:
		change_task_running = true
		await _change_terrain()

func _change_terrain() -> void:
	var tile_positions = get_all_tile_positions(active_tilemap)
	print("Tiles to change: ", tile_positions.size())

	while tile_positions.size() > 0:
		# If terrain change was interrupted, stop the process
		if not is_changing:
			print("Terrain change interrupted!")
			target_tilemap.visible = false  # Hide the target if interrupted
			change_task_running = false
			return

		# Randomly pick a tile position
		var random_index = randi() % tile_positions.size()
		var pos = tile_positions[random_index]
		tile_positions.remove_at(random_index)

		# Get and set tile IDs
		var target_tile_id = target_tilemap.get_cell_source_id(0, pos)
		print("Changing tile at ", pos, " to target tile ID: ", target_tile_id)
		active_tilemap.set_cell(0, pos, target_tile_id)

		# Pause for the specified interval
		await get_tree().create_timer(change_speed).timeout

	# Mark the terrain change as complete
	print("Terrain change complete!")
	active_tilemap = target_tilemap
	forest_tilemap.visible = (active_tilemap == forest_tilemap)
	arctic_tilemap.visible = (active_tilemap == arctic_tilemap)
	is_changing = false
	change_task_running = false

func get_all_tile_positions(tilemap: TileMap) -> Array[Vector2i]:
	var positions: Array[Vector2i] = []
	var used_rect = tilemap.get_used_rect()
	for x in range(used_rect.position.x, used_rect.end.x):
		for y in range(used_rect.position.y, used_rect.end.y):
			var pos = Vector2i(x, y)
			if tilemap.get_cell_source_id(0, pos) != -1:
				positions.append(pos)
	return positions
