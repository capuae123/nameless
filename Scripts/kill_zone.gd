extends Area2D

'''
Responsible for harming player entering it and signaling accordingly. 
Also starts a timer to respawn player when health reaches 0.
'''

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	if 'obj' in body:
		if body.obj == "Player" and get_parent().obj == "Enemy": 
			body.take_dmg(get_parent().dmg)
		elif body.obj == "Enemy" and get_parent().obj == "Attack":
			body.take_dmg(get_parent().dmg)
		
		if body.obj == "Player" and body.health <= 0:
			timer.start()
		elif body.obj == "Enemy" and body.health <= 0:
			body.queue_free()
		print("Inside Killzone")


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
