extends Area2D


@onready var follow: Vector2 = position
@onready var next_pos: Vector2 = position


func interact():
	monitorable = false
	$Animator.play("pick_up")
	$Animator.queue("auto")
	get_node("/root/Root/Player").moved.connect(move)
	get_node("/root/Root/Player").key = get_path()
	next_pos = get_node("/root/Root/Player").position
	global.play_sfx("key")


func move(player_pos: Vector2):
	follow = next_pos
	next_pos = player_pos


func _physics_process(_delta: float):
	position = position.lerp(follow, 0.1)
