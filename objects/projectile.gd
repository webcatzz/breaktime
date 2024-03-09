extends StaticBody2D


var direction: int
var lifespan: float = 3
var speed: float = 1
var vector: Vector2


func _ready():
	$Sprite.frame_coords.y = randi_range(0, 3)
	if direction == 0 or direction == 3:
		$Sprite.frame += 1
	if direction == 0 or direction == 1:
		$Sprite.flip_h = true
	vector = [Vector2(-16, -8), Vector2(16, 8), Vector2(-16, 8), Vector2(16, -8)][direction]
	$Lifespan.start(lifespan)


func _physics_process(delta: float):
	move_and_collide(vector * delta * speed)


func on_collision(body: Node2D):
	if body is StaticBody2D:
		if body.name == "Player":
			global.run.take_damage("airplane")
		else:
			body.queue_free()
	
	queue_free()
