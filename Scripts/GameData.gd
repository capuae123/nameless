extends Node

signal temperature_changed(new_temp: int)  # Declare signal at the top level

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
	if n <= energy:
		energy -= n

func hot_bubble():
	hot_bubbles += 1
	emit_temperature_changed()

func cold_bubble():
	cold_bubbles += 1
	emit_temperature_changed()

func electric_bubbles():
	electric_bubble += 1

func get_temp() -> int:
	temp = hot_bubbles - cold_bubbles
	temp = clamp(temp, -55, 55)  # Clamp the temperature within -55 to 55
	return temp

func change_temp(n: int) -> void:
	temp += n
	temp = clamp(temp, -55, 55)  # Clamp the temperature within -55 to 55
	emit_temperature_changed()
	

# Emit the temperature_changed signal
func emit_temperature_changed() -> void:
	temp = get_temp()
	emit_signal("temperature_changed", temp)
	print(temp)
