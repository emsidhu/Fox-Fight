extends AudioStreamPlayer


func _ready():
	pass


func _on_PlayerHurtSound_finished():
	queue_free()
	if PlayerStats.health <= 0:
		if get_tree().current_scene.name == "TutorialLevel":
# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
		else:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Menus/GameOver.tscn")
