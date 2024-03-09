extends Area2D


func interact():
	if $Dialogue.visible:
		$Dialogue.cont()
		$Animator.play("speak")
	else:
		$Animator.play("speak")
		await $Animator.animation_finished
		$Sprite.frame = 1
		if !global.data.flags_plant.talked_once:
			await $Dialogue.say([
				"EY",
				"wow",
				"youse da first whos tolked 2 me in,",
				"GAWD knows how loang",
				"nobody eva waters me.",
				"do dey think im plastic?",
				"me? plastic??",
				"whadda ya say ya get me sum water, kid",
				"im freakin DYIN ova here"
			])
			global.data.flags_plant.talked_once = true
		elif !global.data.flags_plant.watered:
			if global.run.got_water:
				global.run.got_water = false
				global.data.flags_plant.watered = true
				await $Dialogue.say([
					"OH thank gawd",
					"ooooohhhh yesss",
					"i am released from da icy clutches of death once ahgain",
					"thank you sweet sir"
				])
			else:
				await $Dialogue.say([
					"got da water yet, kid?",
					"then get 2 it",
					"my leaves ah shrivelin as we speak"
				])
		else:
			await $Dialogue.say(["i am indetted to youse.", "forevahmoah!"])
		$Sprite.frame = 0
		$Animator.play("speak")


func on_screen_entered():
	$Sprite.frame = 1
	await get_tree().create_timer(0.5).timeout
	$Sprite.frame = 0
