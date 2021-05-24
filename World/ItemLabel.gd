extends Label


func _ready():
	PlayerStats.connect("health_changed", self, "item_picked_up")


func _on_Chest_opening():
	text = "Press E to pick up the item"

func item_picked_up(health):
	if health > 1:
		text = "Press I to open your inventory"
