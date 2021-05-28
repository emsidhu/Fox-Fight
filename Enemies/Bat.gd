extends "res://Enemies/MeleeEnemy.gd"


# warning-ignore:unused_argument
func _physics_process(delta):
	sprite_flipped = velocity.x < 0
