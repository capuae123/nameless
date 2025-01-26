extends Node2D

#@onready var animation_player = $ColorRect/AnimationPlayer
#@onready var color_rect = $ColorRect
#@export var new_scene : PackedScene

#func change_effects():
	#var transition_layer = $Desert  # Replace with the actual path to your CanvasLayer
	#switch_scene(new_scene)
#
## Function to switch scenes with fade-out
#func switch_scene(new_scene_path: String):
	## Start the fade-out animation
	#animation_player.play("fade_out")
	## Wait for the animation to finish, then load the new scene
	#await animation_player.animation_finished
	#get_tree().change_scene(new_scene_path)
	## Start the fade-in animation
	#animation_player.play("fade_in")

	
func switch_scene():
	await get_tree().create_timer(50).timeout
	get_tree().change_scene_to_file("res://Scenes/scene_2.tscn")
	
func _process(delta: float) -> void:
	switch_scene()
