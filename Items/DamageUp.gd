extends "res://Items/Item.gd"

func _physics_process(_delta):
	if playerDetectionZone.player != null:
		if Input.is_action_just_pressed("pickup"):
			pickup()

func pickup():
	PlayerStats.damage = PlayerStats.base_damage
	for item in AllItems.held_items:
		if item == AllItems.DamageUp:
			PlayerStats.damage += PlayerStats.base_damage * 0.1
	audioStreamPlayer.playing = true
	visible = false
