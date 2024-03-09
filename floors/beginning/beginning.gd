extends Node2D


func _ready():
	get_node("Rooms/CubicleRoom/" + global.run.last_character).queue_free()
	$Player.position = get_node("Rooms/CubicleRoom/" + global.run.character).position
	get_node("Rooms/CubicleRoom/" + global.run.character).queue_free()
