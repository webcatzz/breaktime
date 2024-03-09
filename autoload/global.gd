extends Node


var data: Resource = load("res://data/savegame/savegame.tres")
var run: Resource = load("res://data/run/run.tres")
var employees: PackedStringArray = ["Jim", "Blue", "Holly", "Adrien", "Greg", "NPC6"]

var in_title: bool = false
var random_music = load("res://assets/music/music.tres")

@onready var music = $Music
@onready var sfx = $SFX
@onready var sfx_random = $SFXRandom
@onready var animator = $Animator
@onready var pause_screen = $PauseScreen


func _ready():
	$PauseScreen/Container/Separator/Volume/MasterSlider.value = data.master_volume
	$PauseScreen/Container/Separator/Volume/MusicSlider.value = data.music_volume
	$PauseScreen/Container/Separator/Volume/SfxSlider.value = data.sfx_volume


func save():
	ResourceSaver.save(data, "res://data/savegame/savegame.tres")


# game

func start_game():
	$Overlay.visible = true
	animator.play("fade_out")
	await animator.animation_finished
	
	await new_run()
	
	animator.play_backwards("fade_out")
	await animator.animation_finished
	$Overlay.visible = false


func new_run(last_character: String = "Greg", got_coffee: bool = false, got_water: bool = false):
	run = null
	run = load("res://data/run/run.tres")
	
	run.last_character = last_character
	var employees_without: Array = Array(employees)
	employees_without.erase(run.last_character)
	run.character = employees_without.pick_random()
	
	employees_without = Array(employees)
	employees_without.erase(run.character)
	run.employee_of_the_day = employees_without.pick_random()
	
	run.health = data.max_health
	run.got_coffee = got_coffee
	run.got_water = got_water
	$UI.reconnect()
	get_tree().change_scene_to_file("res://floors/beginning/beginning.tscn")
	await get_tree().process_frame
	
	print("Started new run.")


func next_floor():
	$ElevatorDoors.visible = true
	animator.play("switch_floor")
	await animator.animation_finished
	play_sfx("ding")
	await get_tree().create_timer(1).timeout
	
	await run.on_next_floor()
	$UI/Container/Numbers/LevelInfo/Level.text = "Floor " + str(run.level)
	$UI/Container/Numbers/LevelInfo/Progress.value = run.level
	
	await get_tree().process_frame
	animator.play_backwards("switch_floor")
	await animator.animation_finished
	$ElevatorDoors.visible = false


func game_over():
	get_tree().paused = true
	var run_data: Dictionary = run.end(false)
	get_node("/root/Root/Player/Sprite").clip_children = 1
	get_node("/root/Root/Player/Sprite/Red").visible = true
	$UI.visible = false
	$GameOver.visible = true
	$Modulator.color = Color("181425")
	music.stop()
	play_sfx("game_over")
	await get_tree().create_timer(1).timeout
	
	$GameOver/Container/Paper/Separator/Info/Time.text = Time.get_datetime_string_from_system().replace("T", ", ")
	$GameOver/Container/Paper/Separator/Info/Name.text = run_data.character
	$GameOver/Container/Paper/Separator/Info/ID.text = run_data.number
	$GameOver/Container/Paper/Separator/Info/Time.text = run_data.time_lasted
	$GameOver/Container/Paper/Separator/Info/Cause.text = run_data.death_cause
	$GameOver/Container/Paper/Separator/Message.text = "[center][shake]" + [
		"Try, try, and try again.",
		"Oops...",
		"[color=red]YOU DIED[/color]",
		"The thread of prophecy is severed.",
		"Who put that there?"
	].pick_random() + "[/shake][/center]"
	$GameOver/Container.pivot_offset = $GameOver/Container.size / 2
	
	animator.play("game_over")
	await animator.animation_finished
	$GameOver/Container.grab_focus()


func game_over_confirmed(event: InputEvent):
	if event.is_action_released("ui_accept"):
		animator.play("fade_out")
		await animator.animation_finished
		$GameOver.visible = false
		$Modulator.color = Color.WHITE
		
		new_run(run.character, run.got_coffee, run.got_water)
		
		$GameOver/Container.visible = false
		
		get_tree().paused = false
		get_tree().change_scene_to_file("res://floors/beginning/beginning.tscn")
		await get_tree().process_frame
		animator.play_backwards("fade_out")


func quit_to_title():
	get_tree().change_scene_to_file("res://title.tscn")


# audio

func play_music(music_name: String = ""):
	if music_name.is_empty():
		play_music("kickstart")
#		print("Now playing mix.")
#		music.stream = random_music
#		music.play()
	elif ResourceLoader.exists("res://assets/music/" + music_name + ".mp3"):
		print("Now playing: ", music_name)
		music.stream = load("res://assets/music/" + music_name + ".mp3")
		music.play()
	else:
		printerr("Music not found: ", music_name)


func play_sfx(sfx_name: String, random: bool = false):
	if ResourceLoader.exists("res://assets/sfx/" + sfx_name + ".mp3"):
		if random:
			sfx_random.stream.set_stream(0, load("res://assets/sfx/" + sfx_name + ".mp3"))
			sfx_random.play()
		else:
			sfx.stream = load("res://assets/sfx/" + sfx_name + ".mp3")
			sfx.play()
	else:
		printerr("SFX not found: ", sfx_name)


func toggle_music():
	music.stream_paused = !music.stream_paused


func stop_music():
	music.stop()


func set_volume(value: int, type: int = 0):
	var bus_name = ["Master", "Music", "SFX"][type]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(float(value) / 100))
	data.set(bus_name.to_lower() + "_volume", value)


# misc.


func toggle_pause():
	if pause_screen.visible and !$GameOver.visible:
		animator.play_backwards("pause")
		await animator.animation_finished
	else:
		animator.play("pause")
	pause_screen.visible = !pause_screen.visible
	get_tree().paused = pause_screen.visible


func get_player():
	return get_node("/root/Root/Player")


func toggle_flashing(value: bool):
	data.flashing = value


func _unhandled_key_input(event: InputEvent):
	if event.is_action_released("screenshot"):
		var image = get_viewport().get_texture().get_image()
		image.save_png("res://data/screenshot.png")
