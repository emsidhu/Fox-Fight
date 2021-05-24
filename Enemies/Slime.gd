extends "res://Enemies/MeleeEnemy.gd"


func _physics_process(delta):
	if state == IDLE:
		sprite.playing = false
		sprite.frame = 0
	else:
		sprite.playing = true
	sprite_flipped = velocity.x > 0
