extends Resource


@export var name: String
@export_multiline var random: Array[String] = ["..."]

@export_group("Employee of the Day")
@export_multiline var eotd: String

@export_group("Character-specific")
@export_multiline var jim: String
@export_multiline var blue: String
@export_multiline var holly: String
@export_multiline var adrien: String
@export_multiline var greg: String
@export_multiline var npc6: String


func pick_dialogue() -> PackedStringArray:
	if !global.run.got_custom_dialogue and !global.data.flags_dialogue[name.to_lower() + "_to_" + global.run.character.to_lower()] and get(global.run.character.to_lower()) != "":
		global.run.got_custom_dialogue = true
		global.data.flags_dialogue[name.to_lower() + "_to_" + global.run.character.to_lower()] = true
		return get(global.run.character.to_lower()).split("\n")
	else:
		return random[global.data.run_count % random.size()].split("\n")


func get_eotd_dialogue():
	return eotd.split("\n")
