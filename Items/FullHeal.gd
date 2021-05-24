extends "res://Items/Item.gd"

func _physics_process(_delta):
	if playerDetectionZone.player != null:
		if Input.is_action_just_pressed("pickup"):
			pickup()

func pickup():
	PlayerStats.health = PlayerStats.max_health
	audioStreamPlayer.playing = true
	visible = false

