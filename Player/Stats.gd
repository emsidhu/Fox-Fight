extends Node


export var damage = 75
export var speed = 80
export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health
var base_damage = damage
var base_speed = speed

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	base_damage = damage
	base_speed = speed
	self.health = max_health

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
	

