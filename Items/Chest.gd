extends AnimatedSprite

onready var timer = $Hurtbox/Timer
var is_open = false

func _ready():
	frame = 0


func _on_Hurtbox_area_entered(area):
	if timer.time_left <= 0:
		if area.is_in_group("Hitboxes") and not is_open:
			playing = true
			var item = AllItems.get_item().instance()
			get_parent().get_parent().call_deferred("add_child", item)
			item.call_deferred("set", "global_position", global_position)
			item.get_node("ItemBounce/ItemBounceArea").call_deferred("set", "global_position", global_position + Vector2(0, 12))
			is_open = true
