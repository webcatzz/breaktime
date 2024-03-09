extends Area2D


func interact():
	if %Player.z_index == 0:
		%Player.actually_move(Vector2(-32, -32))
		%Player.z_index = 1
	else:
		%Player.actually_move(Vector2(32, 32))
		%Player.z_index = 0
	if !%Player.key.is_empty(): get_node(%Player.key).z_index = %Player.z_index
