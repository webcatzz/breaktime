extends Area2D


@export var flip: bool = false

var talked_to: bool = false
var dialogue: PackedStringArray
var eotd_dialogue: PackedStringArray


func _ready():
	$Sprite.texture = load("res://assets/characters/" + name.to_lower() + ".png")
	$Sprite.flip_h = flip
	dialogue = load("res://data/dialogue/" + name.to_lower() + ".tres").pick_dialogue()
	if name == global.run.employee_of_the_day:
		eotd_dialogue = load("res://data/dialogue/" + name.to_lower() + ".tres").get_eotd_dialogue()
	$Voice.pitch_scale = {
		"Jim": 0.3,
		"Blue": 0.5,
		"Holly": 1.2,
		"Adrien": 0.6,
		"Greg": 0.8,
		"NPC6": 1,
	}[name]


func interact():
	if $Dialogue.visible:
		$Dialogue.cont()
	else:
		$Animator.play("start")
		if !talked_to and name == global.run.employee_of_the_day:
			talked_to = true
			await $Dialogue.say(eotd_dialogue)
			global.run.defense += 1
			global.data.defense_collected += 1
			$Animator.play("drop_item")
			await $Animator.animation_finished
		else:
			await $Dialogue.say(dialogue)
		$Animator.play("stop")
