extends Node

var current_level = 1 setget set_current_level
var move_speed_modifier = 1
var attack_speed_modifier = 1
var health_modifier = 1

signal level_changed(value)

func set_current_level(value):
	current_level = value
	var new_modifier = 1 + (current_level / 50)
	move_speed_modifier = new_modifier
	attack_speed_modifier = new_modifier
	health_modifier = new_modifier
	emit_signal("level_changed", current_level)
	
