extends Node2D


signal OK
signal faded_in
signal faded_out

@export var sound: String

@onready var container = $Container
@onready var label = $Container/Text
@onready var animator = $Container/Animator


func say(dialogue):
	visible = true
	if dialogue is PackedStringArray or dialogue is Array:
		for line in dialogue:
			await display(line)
	elif dialogue is String:
		await display(dialogue)
	visible = false


func display(text):
	label.text = text
	animator.play("fade_in")
	emit_signal("faded_in")
	await OK
	if modulate.a != 0:
		animator.play("fade_out")
		await animator.animation_finished


func cont():
	emit_signal("OK")


func anim_finished(anim: String):
	if anim == "fade_in":
		emit_signal("faded_out")
