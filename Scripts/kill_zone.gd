extends Area2D

'''
Responsible for harming player entering it and signaling accordingly. 
Also starts a timer to respawn player when health reaches 0.
'''

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	#body.take_dmg(get_parent().enemy_dmg)
	#if body.health <= 0:
		#timer.start()
	print("Inside Killzone")


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
