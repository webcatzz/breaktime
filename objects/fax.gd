extends StaticBody2D


var velocity: Vector2 = Vector2(-256, 128)
var flip: bool = false


func _ready():
	if flip:
		velocity.x = -velocity.x
		$Sprite.flip_h = true


func _physics_process(delta: float):
	move_and_collide(velocity * delta)


func on_collision(body: Node2D):
	if body is StaticBody2D:
		if body.name == "Player":
			global.run.take_damage("fax")
		else:
			body.queue_free()
	$Animator.play("collide")
