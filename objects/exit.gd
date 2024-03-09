extends Area2D


@export var flip: bool = false
var open: bool = false

@onready var player = get_node("/root/Root/Player")


func _ready():
	if flip:
		scale.x = -1


func interact():
	if open:
		player.set_process_unhandled_key_input(false)
		global.play_sfx("elevator_door")
		$Animator.play("open")
		await $Animator.animation_finished
		global.next_floor()
	else:
		if player.key.is_empty():
			global.play_sfx("fail")
		else:
			get_node(player.key).queue_free()
			player.key = ""
			open = true
			$Animator.play("unlock")
			global.play_sfx("lever")
