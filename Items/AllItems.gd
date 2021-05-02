extends Node

const HeartCanister = preload("res://Items/Heart Canister.tscn")

var held_items = []
var all_items = [HeartCanister]

func get_item():
	var choice = all_items[randi() % all_items.size()]
	held_items.append(choice)
	return choice
