extends Area2D


var electrified: bool = true


func _ready():
	global.run.lights_switched.connect(toggle_electrified)
	$Sprite.animation = "electrified" if global.data.flashing else "no_flash"
	$Sprite.speed_scale = randf_range(1, 2)
	$Sprite.flip_h = randf() > 0.5
	$Sprite.flip_v = randf() > 0.5
	$Sprite.play()


func interact():
	get_node("/root/Root/Player").actually_move()
	if electrified: global.run.take_damage("water")
	else:
		for area in get_overlapping_areas():
			if "Water" in area.name and area.position == position + get_node("/root/Root/Player/Raycast").target_position:
				area.interact()
				return
		get_node("/root/Root/Player").move()
		global.play_sfx("slip")


func toggle_electrified(value: bool = !electrified):
	electrified = value
	$Sprite.play("default" if !electrified else "electrified" if global.data.flashing else "no_flash")
	$Sprite.material.light_mode = 1 if electrified else 0
	if !electrified: $Sprite.frame = randi_range(0, 6)
