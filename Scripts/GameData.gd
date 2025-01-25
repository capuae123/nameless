extends Node

var energy = 0

func add_energy() -> void:
	if energy < 100:
		energy += 1
	else:
		energy = 100

# Consumes energy by N amount
func use_energy(n: int) -> void:
	if n<=energy:
		energy -= n
