extends Control

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"

onready var label: Label = $Label

func _ready() -> void:
	label.text = label.text % LevelStats.current_level
	
	var data = {
		"current_level": 1,
		"max_health" : 6,
		"damage" : 75,
		"held_items" : [],
		"speed" : 80
	}
	
	PlayerStats.damage = 75
	PlayerStats.max_health = 6
	PlayerStats.speed = 80
	LevelStats.current_level = 1
	AllItems.held_items = []
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()




func _on_ChangeSceneBtn_button_up():
	PlayerStats.health = PlayerStats.max_health
