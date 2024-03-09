extends Path2D


@export var loop: bool =true

var last_x: float
var is_alert: bool = false
var is_moving: bool = true

@onready var follower = $Follower
@onready var sprite = $Follower/Body/Sprite
@onready var vision = $Follower/Body/Vision
@onready var raycast = $Follower/Body/Raycast


func _ready():
	follower.loop = loop


func _physics_process(_delta):
	sprite.flip_h = position.x <= last_x
	last_x = position.x
	
	if is_alert:
		follower.position = follower.position.move_toward(get_node("/root/Root/Player").position, 1)
		if follower.position.distance_squared_to(get_node("/root/Root/Player").position) < 256:
			global.run.take_damage("assistant_supervisor")
	elif is_moving:
		follower.progress += 0.25
		for body in vision.get_overlapping_bodies():
			if body.name == "Player":
				raycast.target_position = body.global_position - follower.global_position
				if raycast.is_colliding() and raycast.get_collider().name == "Player":
					is_moving = false
					$Modulator.color.r = 1
					global.stop_music()
					$Music.play()
					await get_tree().create_timer(1.675).timeout
					is_alert = true
