extends Area2D


func _ready():
	regenerate()


func interact():
	monitorable = false
	$Sprite.frame = randi_range(2, 3)
	global.play_sfx("leaf")
	global.get_player().actually_move()


func regenerate():
	if !monitorable:
		$Sprite.frame = randi_range(0, 1)
		$Sprite.flip_h = randf() > 0.5
		monitorable = true
