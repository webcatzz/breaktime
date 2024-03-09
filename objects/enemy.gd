extends Node2D


@export var type: String

@onready var direction = $Direction
@onready var animator = $Animator


func interact():
	animator.play("die")
