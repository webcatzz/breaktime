extends Area2D


func interact():
	if $Dialogue.visible:
		$Dialogue.cont()
	else:
		$Dialogue.say([
			"Total runs: " + str(global.data.run_count),
			"Best time: " + str(global.data.best_time.minute) + "m " + str(global.data.best_time.second) + "s",
			"Hearts collected: " + str(global.data.health_collected),
			"Briefcases collected: " + str(global.data.defense_collected),
			"Paperclips collected: " + str(global.data.attack_collected),
		])
