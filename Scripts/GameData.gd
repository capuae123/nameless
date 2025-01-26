extends Node

var energy = 0
var temp = 0
var hot_bubbles = 0
var cold_bubbles = 0
var electric_bubble = 0

func add_energy() -> void:
	if energy < 100:
		energy += 1
	else:
		energy = 100

# Consumes energy by N amount
func use_energy(n: int) -> void:
	if n<=energy:
		energy -= n

func hot_bubble():
	hot_bubbles += 1

func cold_bubble():
	cold_bubbles += 1

func electric_bubbles():
	electric_bubble += 1

func get_temp():
	temp = hot_bubbles - cold_bubbles
	if temp <= 55 and temp >= -55:
		return temp
	else:
		if temp > 55:
			temp = 55
		elif temp < -55:
			temp = -55
		return temp

func  change_temp(n):
	temp += n
