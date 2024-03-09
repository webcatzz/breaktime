extends CanvasLayer


enum Stat {HEALTH, MAX_HEALTH, DEFENSE, ATTACK}


func _ready():
	global.data.max_health_changed.connect(set_value.bind(Stat.MAX_HEALTH))
	set_value(global.data.max_health, Stat.MAX_HEALTH)
	reconnect()


func set_value(value: int, stat: int):
	print("set ", ["hp", "maxhp", "def", "atk"][stat], " to ", value)
	var slide_down: bool = false
	if !visible and !global.in_title:
		slide_down = true
		offset.y = -128
		visible = true
	
	var label: Node
	match stat:
		Stat.HEALTH:
			var tween = get_tree().create_tween()
			tween.tween_property($Container/Numbers/Health, "value", value, 0.2)
			$Container/Numbers/Health/Value/Value.text = str(value)
			label = $Container/Numbers/Health/Value
		Stat.MAX_HEALTH:
			var tween = get_tree().create_tween()
			tween.tween_property($Container/Numbers/Health, "max_value", value, 0.2)
			$Container/Numbers/Health/Value/Max.text = "/" + str(value)
			label = $Container/Numbers/Health/Value
		Stat.DEFENSE:
			label = $Container/Numbers/Defense/Value
			label.text = str(value)
		Stat.ATTACK:
			label = $Container/Numbers/Attack/Value
			label.text = str(value)
	
	var tween = get_tree().create_tween()
	if slide_down: tween.tween_property(label.get_parent(), "position:y", 128, 0.2)
	tween.tween_property(label, "scale", Vector2(1.25, 1.25), 0.2)
	tween.tween_property(label, "scale", Vector2(1, 1), 0.3)
	if value == 0: tween.parallel().tween_property(label.get_parent(), "modulate:a", 0.5, 0.2)
	elif label.get_parent().modulate.a == 0.5: tween.parallel().tween_property(label.get_parent(), "modulate:a", 1, 0.2)
	if slide_down:
		tween.tween_interval(1)
		tween.tween_property(label.get_parent(), "position:y", 0, 0.2)
		await tween.finished
		visible = false
		offset.y = 0


func reconnect():
	global.run.health_changed.connect(set_value.bind(Stat.HEALTH))
	global.run.defense_changed.connect(set_value.bind(Stat.DEFENSE))
	global.run.attack_changed.connect(set_value.bind(Stat.ATTACK))
	set_value(global.run.health, Stat.HEALTH)
	set_value(global.run.defense, Stat.DEFENSE)
	set_value(global.run.attack, Stat.ATTACK)
