extends Control

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var level_number = 1 setget set_level_number
var paused = false setget set_paused
var inventory = false setget set_inventory

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty
onready var levelLabel = $LevelLabel
onready var sceneTree = get_tree()
onready var pauseOverlay: ColorRect = $PauseOverlay
onready var inventoryOverlay: ColorRect = $InventoryOverlay
onready var heartCanisterLabel = $InventoryOverlay/InventoryMenu/HeartCanisterSymbol/NumLabel
onready var damageUpLabel = $InventoryOverlay/InventoryMenu/DamageUpSymbol/NumLabel
onready var fullHealLabel = $InventoryOverlay/InventoryMenu/FullHealSymbol/NumLabel
onready var speedBoostLabel = $InventoryOverlay/InventoryMenu/SpeedBoostSymbol/NumLabel
onready var itemDescription = $InventoryOverlay/ItemDescription
onready var audioStreamPlayer = $AudioStreamPlayer

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
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.inventory = false
		self.paused = !paused
		sceneTree.set_input_as_handled()
	if event.is_action_pressed("inventory"):
		self.paused = false
		self.inventory = !inventory

func set_paused(value: bool) -> void:
	paused = value
	sceneTree.paused = paused
	pauseOverlay.visible = paused

func set_inventory(value):
	inventory = value
	
	heartCanisterLabel.text = "0"
	fullHealLabel.text = "0"
	damageUpLabel.text = "0"
	speedBoostLabel.text = "0"
	
	for item in AllItems.held_items:
		if item == AllItems.HeartCanister:
			heartCanisterLabel.text = str(int(heartCanisterLabel.text) + 1)
		elif item == AllItems.FullHeal:
			fullHealLabel.text = str(int(fullHealLabel.text) + 1)
		elif item == AllItems.DamageUp:
			damageUpLabel.text = str(int(damageUpLabel.text) + 1)
		elif item == AllItems.SpeedBoost:
			speedBoostLabel.text = str(int(speedBoostLabel.text) + 1)

	sceneTree.paused = inventory
	inventoryOverlay.visible = inventory

func _on_ResumeButton_button_up():
	self.paused = false


func _on_HeartCanisterSymbol_mouse_entered():
	itemDescription.text = "Increases Max Health By One"


func _on_FullHealSymbol_mouse_entered():
	itemDescription.text = "Fully Heals You"


func _on_DamageUpSymbol_mouse_entered():
	itemDescription.text = "Increases Damage Dealt"


func _on_Symbol_mouse_exited():
	itemDescription.text = ""


func _on_SpeedBoostSymbol_mouse_entered():
	itemDescription.text = "Increases Move Speed"


func _on_button_down():
	audioStreamPlayer.playing = true


func _on_AudioStreamPlayer_finished():
	audioStreamPlayer.playing = false


func _on_button_up():
	if not get_tree().current_scene.is_in_group("Tutorial"): 
		var data = {
			"current_level": 1,
			"max_health" : 6,
			"damage" : 75,
			"held_items" : [],
			"speed" : 80
		}
		
		var file = File.new()
		var error = file.open(save_path, File.WRITE)
		if error == OK:
			file.store_var(data)
			file.close()
