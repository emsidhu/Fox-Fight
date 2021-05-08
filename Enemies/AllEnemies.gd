extends Node

const Bat = preload("res://Enemies/Bat.tscn")
const Slime = preload("res://Enemies/Slime.tscn")
const Mushroom = preload("res://Enemies/Mushroom.tscn")

var enemy_list = [Bat, Slime, Mushroom]

func get_enemy():
	#use str2var() for possible enemy spawns later
	var choice = enemy_list[randi() % enemy_list.size()]
	return choice
