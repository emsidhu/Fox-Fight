extends Control

onready var audioStreamPlayer = $AudioStreamPlayer

func _ready():
	PlayerStats.damage = 75
	PlayerStats.max_health = 6
	PlayerStats.speed = 80
	LevelStats.current_level = 1
	AllItems.held_items = []
	PlayerStats.health = PlayerStats.max_health


func _on_AudioStreamPlayer_finished():
	audioStreamPlayer.playing = false


func _on_button_down():
	audioStreamPlayer.playing = true
