extends "res://Enemies/MeleeEnemy.gd"


func _physics_process(delta):
	if state == IDLE:
		sprite.animation = "idle"
	else:
		sprite.animation = "moving"
	sprite_flipped = velocity.x < 0
