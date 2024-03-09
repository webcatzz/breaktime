extends Area2D


func interact():
	%Player.actually_move()
	$Dialogue.say("*grumble, mumble*")
