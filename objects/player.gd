extends StaticBody2D


signal moved

var damageable: bool = true
var key: NodePath

@onready var sprite = $Sprite
@onready var raycast = $Raycast
@onready var step_sfx = $Step
@onready var animator = $Animator


func _ready():
	sprite.play(global.run.character.to_lower())
	global.data.damaged.connect(animator.queue.bind("damage"))
	global.data.shielded.connect(animator.queue.bind("block"))


func _unhandled_key_input(event):
	if event.is_action_released("ui_up"): move(Vector2(-16, -8))
	elif event.is_action_released("ui_down"): move(Vector2(16, 8))
	elif event.is_action_released("ui_left"): move(Vector2(-16, 8))
	elif event.is_action_released("ui_right"): move(Vector2(16, -8))
	elif event.is_action_released("ui_cancel"): global.toggle_pause()

func move(direction: Vector2 = raycast.target_position):
	raycast.target_position = direction
	await get_tree().process_frame
	if raycast.is_colliding():
		if raycast.get_collider() is Area2D:
			if raycast.get_collider().monitorable:
				if raycast.get_collider().script == null:
					raycast.get_collider().get_parent().interact()
				else:
					raycast.get_collider().interact()
			else:
				actually_move(direction)
		else:
			global.play_sfx("fail")
	else:
		actually_move(direction)
	
	sprite.flip_h = bool(sign(direction.x) - 1)


func actually_move(direction: Vector2 = raycast.target_position):
	position += direction
	animator.play("move")
	step_sfx.play()
	
	emit_signal("moved", position)


func interact():
	animator.play("interact_fail")
	global.play_sfx("fail")


func pan_to(coords: Vector2, time: float = 0.2):
	damageable = false
	set_process_unhandled_key_input(false)
	await get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).tween_property($Camera, "global_position", coords, time).finished


func pan_back(time: float = 0.2):
	await get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).tween_property($Camera, "position", Vector2.ZERO, time).finished
	set_process_unhandled_key_input(true)
	damageable = true
