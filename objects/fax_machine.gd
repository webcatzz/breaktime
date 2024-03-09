extends StaticBody2D


@export var flip: bool = false
@export var fire_up: bool = false
var fax = load("res://objects/fax.tscn")


func _ready():
	if flip:
		$Sprite.flip_h = true


func fire():
	$Animator.play("fire")


func add_proj():
	var proj = fax.instantiate()
	proj.flip = flip
	if fire_up: proj.velocity.y = -proj.velocity.y
	add_child(proj)


func die():
	$Animator.play("die")
