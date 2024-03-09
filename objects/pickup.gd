extends Area2D


var type: int


func _ready():
	if global.run.health != global.data.max_health:
		type = randi_range(1, 3)
	else:
		type = randi_range(2, 3)
	$Sprites/Icon.frame = [1, 2, 5][type - 1]


func interact():
	get_node("/root/Root/Player").set_process_unhandled_key_input(false)
	$SFX.play()
	$Animator.play("pick_up")
	await $Animator.animation_finished
	
	if type != 3:
		var type_string = ["health", "defense"][type - 1]
		global.data.set(type_string, global.run.get(type_string) + 1)
		global.data.set(type_string + "_collected", global.data.get(type_string + "_collected") + 1)
	else:
		global.run.got_coffee = true
	
	queue_free()
	get_node("/root/Root/Player").set_process_unhandled_key_input(true)
