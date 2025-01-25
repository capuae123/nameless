extends Area2D

'''
Responsible for detecting if player has entered or exited the detection area.
Sends signals accordingly.
'''

var player = null


func _on_body_entered(body: Node2D) -> void:
	player = body


func _on_body_exited(body: Node2D) -> void:
	player = null


func can_see_player():
	return player != null
	
