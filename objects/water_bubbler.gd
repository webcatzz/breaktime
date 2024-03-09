extends Area2D


func interact():
	if !global.run.got_water:
		global.run.got_water = true
		$Animator.play("collect")
	else:
		global.play_sfx("fail")
