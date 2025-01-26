extends Node2D

@onready var data = $"/root/GameData"

@export var Desert = "res://Scenes/desertlayout.tscn"
@export var Forest = "res://Scenes/forestlayout.tscn"
@export var Arctic = "res://Scenes/arcticlayout.tscn"

var temp = 55


#@onready var animation_player = $ColorRect/AnimationPlayer
#@onready var color_rect = $ColorRect
#@export var new_scene : PackedScene

## Function to switch scenes with fade-out
#func switch_scene(new_scene_path: String):
	## Start the fade-out animation
	#animation_player.play("fade_out")
	## Wait for the animation to finish, then load the new scene
	#await animation_player.animation_finished
	#get_tree().change_scene(new_scene_path)
	## Start the fade-in animation
	#animation_player.play("fade_in")


func _process(delta: float) -> void:
	temp = data.get_temp()
	if temp <= 12:
		get_tree().change_scene_to_file(Forest)
