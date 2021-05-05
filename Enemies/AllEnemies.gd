extends Node

const Bat = preload("res://Enemies/Bat.tscn")


var enemy_list = [Bat]

func get_enemy():
	#use str2var() for possible enemy spawns later
	var choice = enemy_list[randi() % enemy_list.size()]
	return choice
