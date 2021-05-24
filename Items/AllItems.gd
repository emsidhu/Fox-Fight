extends Node

const HeartCanister = preload("res://Items/Heart Canister.tscn")
const FullHeal = preload("res://Items/FullHeal.tscn")
const DamageUp = preload("res://Items/DamageUp.tscn")
const SpeedBoost = preload("res://Items/SpeedBoost.tscn")

var held_items = []
var all_items = [HeartCanister, FullHeal, DamageUp, SpeedBoost]

func get_item():
	var choice = all_items[randi() % all_items.size()]
	held_items.append(choice)
	return choice
