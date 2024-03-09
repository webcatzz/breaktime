extends StaticBody2D


func _ready():
	global.run.lights_switched.connect(toggle_on)
	for sprite in $Sprite.get_children():
		sprite.frame = randi_range(0, (sprite.hframes * sprite.vframes) - 1)


func toggle_on(value: bool):
	$Sprite/Screen.visible = value
