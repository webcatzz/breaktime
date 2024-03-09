extends Node2D


@export var initial_delay: float = 0
@export var delay: float = 3

@export_group("Projectile")
@export_enum("Up", "Down", "Left", "Right") var direction: int
@export var lifespan: float = 3
@export var speed: float = 1

var scene: PackedScene = load("res://objects/projectile.tscn")


func _ready():
	if initial_delay > 0:
		$Timer.start(initial_delay)
		await $Timer.timeout
	$Timer.start(delay)


func loop():
	var projectile = scene.instantiate()
	projectile.direction = direction
	projectile.lifespan = lifespan
	add_child(projectile)
	$Timer.start()
