extends Area2D


signal pressed


func interact():
	get_node("/root/Root/Player").actually_move(get_node("/root/Root/Player").raycast.target_position)
	emit_signal("pressed")
	$Sprite.frame = 1
	await get_tree().create_timer(1).timeout
	$Sprite.frame = 0
