extends Node


@onready var label = $Label
@onready var data = $"/root/GameData"


func _ready() -> void:
	label.text = str(data.energy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(data.energy)
