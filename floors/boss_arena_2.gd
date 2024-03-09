extends Node2D


func _ready():
	global.get_player().set_process_unhandled_key_input(false)
	await $Entrance/Animator.animation_finished
	await $Boss2/BossBar.anim_load()
	$Objects/FaxMachines/Timer.start(5)


func on_second_phase():
	global.get_player().set_process_unhandled_key_input(false)
	$Objects/FaxMachines/Timer.stop()
	$Animator.play("fade")
	await $Animator.animation_finished
	
	$Borders/Collision.polygon = [Vector2(-240, 0), Vector2(0, -120), Vector2(240, 0), Vector2(0, 120)]
	$TileMap/Outer.visible = false
	global.get_player().position = Vector2(-96, 48)
	$Boss2.position = Vector2(96, -48)
	
	$Animator.play_backwards("fade")
	await $Animator.animation_finished
	global.get_player().set_process_unhandled_key_input(true)
	$Objects/FaxMachines/Timer.start(3)


func on_third_phase():
	global.get_player().set_process_unhandled_key_input(false)
	$Objects/FaxMachines/Timer.stop()
	$Animator.play("fade")
	await $Animator.animation_finished
	
	$Borders/Collision.polygon = [Vector2(-144, 0), Vector2(0, -72), Vector2(144, 0), Vector2(0, 72)]
	$TileMap/Inner.visible = false
	global.get_player().position = Vector2(-48, 24)
	$Boss2.position = Vector2(48, -24)
	
	$Animator.play_backwards("fade")
	await $Animator.animation_finished
	global.get_player().set_process_unhandled_key_input(true)
	$Objects/FaxMachines/Timer.start(1)


func on_boss_defeated():
	global.get_player().set_process_unhandled_key_input(false)
	$Objects/FaxMachines/Timer.stop()
	$Animator.play("fade")
	await $Animator.animation_finished
	
	$Borders/Collision.polygon = [Vector2(-144, 0), Vector2(0, -72), Vector2(48, -48), Vector2(176, -112), Vector2(160, -120), Vector2(192, -136), Vector2(272, -96), Vector2(240, -80), Vector2(224, -88), Vector2(96, -24), Vector2(144, 0), Vector2(0, 72)]
	$Objects/Key.visible = true
	$Objects/Key.monitorable = true
	
	$Animator.play_backwards("fade")
	await $Animator.animation_finished
	global.get_player().set_process_unhandled_key_input(true)
	
	$Animator.play("open_bridge")


func on_fax_timeout():
	for i in range(8):
		if randf() > 0.75:
			get_node("Objects/FaxMachines/" + str(i + 1) + "/Animator").play("charge")
