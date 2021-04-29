extends Area2D

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended
func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	
	timer.start(duration)
	self.invincible = true

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	collisionShape.set_deferred("disabled", true)


func _on_Hurtbox_invincibility_ended():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	collisionShape.set_deferred("disabled", false)
