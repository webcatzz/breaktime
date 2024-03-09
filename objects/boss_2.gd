extends StaticBody2D


enum State {IDLE, ATTACK}
var state: int = State.IDLE:
	set(value):
		state = value
		$Animator.play(["idle", "attack"][value])
		match value:
			State.IDLE:
				$Collision.disabled = false
			State.ATTACK:
				$Collision.disabled = true
				$SFX.stream = sfx_charge
				$SFX.play()
var target_pos: Vector2:
	set(value):
		target_pos = value
		$Sprite.flip_h = target_pos.x >= 0

var sfx_charge: AudioStreamMP3 = load("res://assets/sfx/boss2_charge.mp3")


func choose_action():
	if $Detector.overlaps_body(global.get_player()):
		target_pos = Vector2(-1.6, -0.8) * (position - global.get_player().position).sign()
		state = State.ATTACK
		print("Boss2: Charging towards " + str(target_pos * 10))


func _physics_process(_delta):
	match state:
		State.IDLE:
			pass
		State.ATTACK:
			if !test_move(Transform2D(0, position), target_pos):
				move_and_collide(target_pos)
			else:
				state = State.IDLE


func on_hurtbox_body_entered(body: Node2D):
	if body.name == "Player":
		global.run.take_damage("supervisor")
