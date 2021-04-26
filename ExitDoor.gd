extends Area2D

signal leaving_level

func _on_ExitDoor_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("leaving_level")
