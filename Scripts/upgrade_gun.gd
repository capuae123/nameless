extends Button

@export var gun_cost = 30
@onready var data = $"/root/GameData"

func  upgrade():
	data.use_energy(gun_cost)
