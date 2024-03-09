extends Node2D


signal at_origin

var speed: float = 0.5
var can_move: bool = false
var last_x: float = 0


func _ready():
	global.stop_music()
	await global.run.lights_switched
	await $BossBar.anim_load()
	can_move = true


func _physics_process(_delta):
	if can_move:
		position = position.move_toward(global.get_player().position, speed)
		if position.distance_squared_to(global.get_player().position) < 256:
			can_move = false
			global.run.take_damage("assistant_supervisor")
			$Timer.start(1)
			await $Timer.timeout
			can_move = true
		
		$Sprite.flip_h = position.x <= last_x
#		if position.x > last_x: $Sprite.flip_h = false
#		else: $Sprite.flip_h = true
		last_x = position.x
	if position.distance_to(Vector2(240, -120)) < 256:
		emit_signal("at_origin")


func on_terminal_activated(terminal: Area2D):
	speed *= 0.5
	await terminal.activated
	speed /= 0.5
	if get_node("/root/Root/Objects/Terminals/Terminal1").active and get_node("/root/Root/Objects/Terminals/Terminal2").active and get_node("/root/Root/Objects/Terminals/Terminal3").active and get_node("/root/Root/Objects/Terminals/Terminal4").active:
		$BossBar.take_damage()
		for i in range(4):
			get_node("/root/Root/Objects/Terminals/Terminal" + str(i + 1)).reset()
		
		can_move = false
		await global.get_player().pan_to(global_position, 1)
		global.play_sfx("boss1_hurt")
		$Animator.play("take_damage" if $BossBar.health != 0 else "die")
		await $Animator.animation_finished
		if speed == 0.5: speed = 0.75
		elif speed == 0.75: speed = 1
		await global.get_player().pan_back(1)
		can_move = true
		
		if $BossBar.health == 0:
			get_node("/root/Root/Animator").play("activated")
			queue_free()
