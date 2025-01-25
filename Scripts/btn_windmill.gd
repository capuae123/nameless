extends Button

@onready var data = $"/root/GameData"
@export var cost = 20
@export var child_scene: PackedScene						# SCENE TO BE SPAWNED
@export var n_spawns = 4									# NUMBER OF SPAWNS
@export var spawn_points: Array[Vector2] = [				# X & Y LOCATIONS OF EACH SPAWN
	Vector2(100, 100),
	Vector2(200, 200),
	Vector2(300, 300),
	Vector2(400, 400)
]

var count: int = 0


func _on_pressed() -> void:
	spawn_windmill()


func spawn_windmill():
	if count <= n_spawns:
		var child = child_scene.instantiate()
		add_child(child)
		child.position = spawn_points[n_spawns]
		count -= 1
