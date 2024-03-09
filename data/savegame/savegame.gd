extends Resource


signal max_health_changed

signal damaged
signal shielded


@export var max_health: int = 1:
	set(value):
		max_health = value
		emit_signal("max_health_changed", value)

@export var run_count: int

@export_group("Flags", "flags_")
@export var flags_dialogue: Dictionary = {
	"jim_to_jim": false,
	"jim_to_blue": false,
	"jim_to_holly": false,
	"jim_to_adrien": false,
	"jim_to_greg": false,
	"jim_to_npc6": false,
	"blue_to_jim": false,
	"blue_to_blue": false,
	"blue_to_holly": false,
	"blue_to_adrien": false,
	"blue_to_greg": false,
	"blue_to_npc6": false,
	"holly_to_jim": false,
	"holly_to_blue": false,
	"holly_to_holly": false,
	"holly_to_adrien": false,
	"holly_to_greg": false,
	"holly_to_npc6": false,
	"adrien_to_jim": false,
	"adrien_to_blue": false,
	"adrien_to_holly": false,
	"adrien_to_adrien": false,
	"adrien_to_greg": false,
	"adrien_to_npc6": false,
	"greg_to_jim": false,
	"greg_to_blue": false,
	"greg_to_holly": false,
	"greg_to_adrien": false,
	"greg_to_greg": false,
	"greg_to_npc6": false,
	"npc6_to_jim": false,
	"npc6_to_blue": false,
	"npc6_to_holly": false,
	"npc6_to_adrien": false,
	"npc6_to_greg": false,
	"npc6_to_npc6": false,
}
@export var flags_gifted: Dictionary = {
	"Jim": false,
	"Blue": false,
	"Holly": false,
	"Adrien": false,
	"Greg": false,
	"NPC6": false,
}
@export var flags_plant: Dictionary = {
	"talked_once": false,
	"got_water": false,
	"watered": false,
}

@export_group("Stats")
@export var health_collected: int
@export var defense_collected: int
@export var attack_collected: int
@export var best_time: Dictionary = {"minute": 0, "second": 0}

@export_group("Settings")
@export_range(0, 100) var master_volume: int = 100
@export_range(0, 100) var music_volume: int = 100
@export_range(0, 100) var sfx_volume: int = 100
@export var flashing: bool = true


func consider_new_time(minutes: int, seconds: int):
	var new_time: Dictionary = {"minute": minutes, "second": seconds}
	
	if new_time.minute < best_time.minute or new_time.minute == best_time.minute and new_time.second < best_time.second:
		best_time = new_time
		return true
	else:
		return false
