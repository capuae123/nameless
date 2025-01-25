extends Node

@export var energy = 100

func add_energy() -> void:
	energy += 1

# Consumes energy by N amount
func use_energy(n: int) -> void:
	if n<=energy:
		energy -= n
