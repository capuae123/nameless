extends Node2D

@onready var timer = $Timer
@onready var data = $"/root/GameData"

func is_windy():
	timer.start(10)
	#print("timer started")

func _on_timer_timeout() -> void:
	data.add_energy()
	#print("timer stopped")

func _ready() -> void:
	await is_windy()
