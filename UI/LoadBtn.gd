tool 
extends Button

const SAVE_DIR = "user://saves/"

export(String, FILE) var next_scene_path: = ""

var save_path = SAVE_DIR + "save.dat"



func _ready():
	disabled = false
	var file = File.new()
	var error = file.open(save_path, File.READ)
	if error == OK:
		var data = file.get_var()
		file.close()
		if data != null:
			if data["current_level"] == 1 or not file.file_exists(save_path):
				disabled = true
				print("1")
		else:
			disabled = true
			print("2")
	else:
		disabled = true
		print("3")

func _on_button_up():
	var file = File.new()
	var error = file.open(save_path, File.READ)
	
	if error == OK:
		var data = file.get_var()
		file.close()
		PlayerStats.damage = data["damage"]
		PlayerStats.max_health = data["max_health"]
		PlayerStats.speed = data["speed"]
		LevelStats.current_level = data["current_level"]
		AllItems.held_items = data["held_items"]
		PlayerStats.health = PlayerStats.max_health
	

	get_tree().paused = false
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""
