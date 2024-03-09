extends Area2D


signal activation_started
signal activated

@export var flip: bool = false
var active: bool = false


func _ready():
	if flip:
		$Sprite.scale.x = -1
		$Collision.scale.x = -1


func interact():
	if !active:
		global.get_player().set_process_unhandled_key_input(false)
		
		emit_signal("activation_started", self)
		$Sprite/Screen.play("default")
		$SFX.play()
		var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
		tween.tween_property($Sprite/Bar, "value", 100, 3)
		tween.tween_property(get_node("/root/Root/Player/Camera"), "zoom", Vector2(6, 6), 3)
		await tween.finished
		get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(get_node("/root/Root/Player/Camera"), "zoom", Vector2(5, 5), 0.2)
		$Sprite/Indicator.color = Color("63c74d")
		active = true
		emit_signal("activated")
		
		global.get_player().set_process_unhandled_key_input(true)
	else:
		global.play_sfx("fail")


func reset():
	active = false
	$Sprite/Screen.frame = 0
	$Sprite/Bar.value = 0
	$Sprite/Indicator.color = Color("e43b44")
