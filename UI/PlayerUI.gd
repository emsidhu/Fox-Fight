extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var level_number = 1 setget set_level_number

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty
onready var levelLabel = $HBoxContainer/VBoxContainer/LevelLabel

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts*15


func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts*15
	
func set_level_number(value):
	level_number = value
	levelLabel.text = str(level_number)
	

func _ready():
	self.level_number = LevelStats.current_level
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
# warning-ignore:return_value_discarded
	LevelStats.connect("level_changed", self, "set_level_number")
