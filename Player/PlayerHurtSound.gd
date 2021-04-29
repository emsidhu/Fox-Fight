extends AudioStreamPlayer


func _ready():
	pass


func _on_PlayerHurtSound_finished():
	queue_free()
