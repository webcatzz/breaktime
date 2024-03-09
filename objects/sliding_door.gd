extends StaticBody2D


@export var flip: bool = false


func _ready():
	if flip:
		scale.x = -1


func interact():
	$Usebox.monitorable = false
	$Animator.play("slide")
	await $Animator.animation_finished
	$Collision.disabled = true
	
	$Timer.start()
	await $Timer.timeout
	
	$Collision.disabled = false
	$Animator.play_backwards("slide")
	await $Animator.animation_finished
	$Usebox.monitorable = true
