extends Node

var current_level = 1 setget set_current_level
var stat_multiplier = 1

signal level_changed(value)

func set_current_level(value):
	current_level = value
	stat_multiplier = 1 + (current_level / 50)
	emit_signal("level_changed", current_level)
	
