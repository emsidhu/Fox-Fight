extends AnimatedSprite

onready var timer = $Hurtbox/Timer
var is_open = false

signal opening

func _ready():
	frame = 0


func _on_Hurtbox_area_entered(area):
	if timer.time_left <= 0:
		if area.is_in_group("Hitboxes") and not is_open:
			emit_signal("opening")
			playing = true
			var item = AllItems.get_item().instance()
			get_parent().get_parent().call_deferred("add_child", item)
			item.global_position = global_position
			item.get_node("ItemBounce/ItemBounceArea").global_position = global_position + Vector2(0, 12)
			is_open = true
