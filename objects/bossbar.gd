extends CanvasLayer


signal play_music
signal anim_finished

@export var boss_name: String = "Boss"
@export var max_health: int = 10
var health: int


func _ready():
	health = max_health
	$Margins/Separator/Name.text = boss_name
	$Margins/Separator/Health.max_value = max_health


func anim_load():
	await global.get_player().pan_to(get_parent().global_position, 1)
	
	$Animator.play("load")
	emit_signal("play_music")
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Margins/Separator/Health, "value", $Margins/Separator/Health.max_value, 1)
	tween.tween_interval(1)
	await tween.finished
	
	await global.get_player().pan_back(1)
	emit_signal("anim_finished")


func take_damage(value: int = 1):
	print("boss took ", value, " damage, new value ", health)
	health -= value
	get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).tween_property($Margins/Separator/Health, "value", health, 0.2)
