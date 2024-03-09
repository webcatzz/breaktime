extends Area2D


var on: bool = true


func interact():
	on = !on
	$Sprite/Lever.frame = 0 if on else 1
	$Sprite/Lever/Indicator.color = Color("63c74d") if on else Color("ff0044")
	$Modulator.color = Color.WHITE if on else Color("8c8a92")
	$Animator.play("turn_on" if on else "turn_off")
	global.play_sfx("lever")
	global.run.emit_signal("lights_switched", on)
