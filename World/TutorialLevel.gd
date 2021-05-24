extends Node2D

onready var levelLabel = $UI/PlayerUI/LevelLabel

func _ready():
	levelLabel.visible = false
	PlayerStats.health = 0.5


func _on_ExitDoor_leaving_level():
	levelLabel.visible = true
	get_tree().change_scene("res://Menus/MainMenu.tscn")

