tool 
extends Button

const SAVE_DIR = "user://saves/"

export(bool) var should_quit = false
export(String, FILE) var next_scene_path: = ""


var save_path = SAVE_DIR + "save.dat"

func _on_button_up():
	var data = {
		"current_level": LevelStats.current_level,
		"max_health" : PlayerStats.max_health,
		"damage" : PlayerStats.damage,
		"speed" : PlayerStats.speed,
		"held_items" : AllItems.held_items
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)

	if error == OK:
		file.store_var(data)
		file.close()
	
	if should_quit:
		get_tree().quit()
	else:
		get_tree().paused = false
		get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""
