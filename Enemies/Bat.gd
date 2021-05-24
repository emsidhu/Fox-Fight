extends "res://Enemies/MeleeEnemy.gd"


func _physics_process(delta):
	sprite_flipped = velocity.x < 0
