extends Control

onready var title = $Title

func _ready():
	title.text = title.text % str(int(LevelStats.current_level) - 1)

func _unhandled_key_input(event):
	if event.is_action_released("attack"):
		get_tree().paused = false
		get_tree().change_scene("res://World/World.tscn")
