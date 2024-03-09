extends Resource


signal floor_changed
signal lights_switched

signal damaged
signal shielded

signal health_changed
signal defense_changed
signal attack_changed

@export_enum("Jim", "Blue", "Holly", "Adrien", "Greg", "NPC6") var character: String = "Jim"
@export_enum("Jim", "Blue", "Holly", "Adrien", "Greg", "NPC6") var last_character: String = "Greg"
@export_enum("Jim", "Blue", "Holly", "Adrien", "Greg", "NPC6", "Supervisor", "Plant") var employee_of_the_day: String = "Supervisor"

@export var health: int = 0:
	set(value):
		health = value
		emit_signal("health_changed", value)
@export var defense: int = 0:
	set(value):
		defense = value
		emit_signal("defense_changed", value)
@export var attack: int = 0:
	set(value):
		attack = value
		emit_signal("attack_changed", value)

@export_range(0, 18) var level: int = 0:
	set(value):
		level = value
		emit_signal("floor_changed", value)
@export var visited_floors: PackedInt32Array = []
@export var unvisited_floors: Array = range(4)

@export var time_started: int = 0
@export var time_ended: int = 0
@export var death_cause: String

@export var got_custom_dialogue: bool = false
@export var got_coffee: bool = false
@export var got_water: bool = false


func take_damage(cause: String = ""):
	if global.get_player().damageable:
		if defense > 0:
			defense -= 1
			emit_signal("shielded")
			global.play_sfx("block")
		else:
			health -= 1
			death_cause = cause
			emit_signal("damaged")
			if health == 0:
				global.game_over()
			else:
				global.play_sfx("hit")


func on_next_floor():
	level += 1
	print("Switched to floor " + str(level))
	match level:
		5: #6
			global.get_tree().change_scene_to_file("res://floors/boss_arena_1.tscn")
		6:
			global.get_tree().change_scene_to_file("credits.tscn")
		12:
			global.get_tree().change_scene_to_file("res://floors/boss_arena_2.tscn")
		18:
			global.get_tree().change_scene_to_file("res://floors/boss_arena_3.tscn")
		_:
			if level == 1:
				time_started = Time.get_ticks_msec()
				global.data.run_count += 1
				global.play_music()
				global.get_node("UI").visible = true
			randomize()
			var new_floor = unvisited_floors.pick_random()
			global.get_tree().change_scene_to_file("res://floors/" + str(new_floor) + ".tscn")
			await global.get_tree().process_frame
			unvisited_floors.erase(new_floor)


func end(successful: bool):
	time_ended = Time.get_ticks_msec()
	var time_sec: int = ((time_ended - time_started) / 1000)
	var time_sec_r: int = ((time_ended - time_started) / 1000) % 60
	if successful:
		global.data.consider_new_time(time_sec - time_sec_r, time_sec_r)
	else:
		return {
			"character": character,
			"number": str(global.data.run_count),
			"floor": str(level),
			"time_lasted": str(time_sec - time_sec_r) + "m " + str(time_sec_r) + "s",
			"death_cause": {
				"fax": ["Papercut", "Unfamiliarity with common dangers of faxing", "Left the fax machine running"],
				"water": ["Mild static shock", "Slipped", 'Failure to observe "Wet Floor" signs'],
				"assistant_supervisor": ["Failure to meet work quota", "Failed to meet expectations", "Disrespectful behavior"],
				"airplane": ["Playing with paper airplanes on the job", "Papercut", "Poked"],
				"": ["[REDACTED]"],
			}[death_cause].pick_random(),
			"got_water": str(got_water),
		}
