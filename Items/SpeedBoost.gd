extends "res://Items/Item.gd"

func _physics_process(_delta):
	if playerDetectionZone.player != null:
		if Input.is_action_just_pressed("pickup"):
			pickup()

func pickup():
	PlayerStats.speed = PlayerStats.base_speed
	for item in AllItems.held_items:
		if item == AllItems.SpeedBoost:
			PlayerStats.speed += PlayerStats.base_speed * 0.1
	audioStreamPlayer.playing = true
	visible = false
