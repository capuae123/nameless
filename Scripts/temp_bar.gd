extends Node2D

'''
desert = 55 (position too)
ice age = -55 (position too)
forest = 20 to -20 (position too)
each bubble = 1
'''

@onready var indicator = $Indicator_Sprite2D
@onready var label = $Label
@onready var data = $"/root/GameData"

var start = Vector2i(0,0)
var temp = 0

func _process(delta: float) -> void:
	temp = data.hot_bubbles - data.cold_bubbles
	if temp <= 55 and temp >= -55:
		label.text = str(temp)+"°C"
		indicator.position = Vector2i(temp,0)
	else:
		if temp < 55:
			temp = 55
		elif temp > -55:
			temp = -55
