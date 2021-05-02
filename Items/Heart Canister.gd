extends "res://Items/Item.gd"

func _physics_process(delta):
	if playerDetectionZone.player != null:
		if Input.is_action_just_pressed("pickup"):
			pickup()

func pickup():
	PlayerStats.max_health += 1
	PlayerStats.health += 1
	queue_free()
