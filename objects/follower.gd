extends PathFollow2D


var is_following: bool = true
var last_x: float


func _physics_process(delta: float):
	if is_following:
		progress += 0.25
		get_child(0).get_node("Sprite").flip_h = true if position.x < last_x else false
		last_x = position.x


func set_following(value: bool):
	is_following = value
