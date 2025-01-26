extends Node2D

@onready var data = $"/root/GameData"

@export var Desert = "res://Scenes/desertlayout.tscn"
@export var Forest = "res://Scenes/forestlayout.tscn"
@export var Arctic = "res://Scenes/arcticlayout.tscn"

var temp = 55

func _process(delta: float) -> void:
	temp = data.get_temp()
	if temp < -12:
		get_tree().change_scene_to_file(Arctic)
	elif temp > 12:
		get_tree().change_scene_to_file(Desert)
