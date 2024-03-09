extends Area2D


var ticker: int = 0


func interact():
	if $Dialogue.visible:
		$Dialogue.cont()
	else:
		match ticker:
			0:
				$Dialogue.say("The key's just out of reach.")
			1:
				$Dialogue.say("Maybe you could find another way around...?")
			_:
				$Dialogue.say("Try climbing up those books.")
		ticker += 1
