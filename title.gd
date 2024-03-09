extends PanelContainer


func _ready():
	global.in_title = true
	global.get_node("UI").visible = false
	$Separator/Buttons/Settings/Sliders/MasterSlider.value = global.data.master_volume
	$Separator/Buttons/Settings/Sliders/MusicSlider.value = global.data.music_volume
	$Separator/Buttons/Settings/Sliders/SfxSlider.value = global.data.sfx_volume
	$Separator/Buttons/Settings/Flashing.button_pressed = global.data.flashing


func start():
	global.in_title = false
	global.start_game()


func quit():
	global.save()
	get_tree().quit()


func reset():
	var new_data = Resource.new()
	new_data.script = load("res://data/player/player.gd")
	global.player = new_data
	global.save()


func set_master_volume(value: int):
	global.set_volume(value)


func set_music_volume(value: int):
	global.set_volume(value, 1)


func set_sfx_volume(value: int):
	global.set_volume(value, 2)


func toggle_flashing(value: bool):
	global.toggle_flashing(value)
