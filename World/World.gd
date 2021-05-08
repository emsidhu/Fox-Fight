extends Node2D

const Player = preload("res://Player/Player.tscn")
const Exit = preload("res://World/ExitDoor.tscn")
const Chest = preload("res://Items/Chest.tscn")

var borders = Rect2(1, 1, 46, 41)
var enemies = []
var num_of_enemies = 10
var num_of_chests = 0
var chest_spawn_chance = 0
var level_num = 0
var objects = []

onready var wallTileMap = $WallTileMap
onready var dirtPathTileMap = $DirtPathTileMap
onready var camera2D = $Camera2D
onready var ySort = $YSort

func _ready():
	num_of_enemies += level_num
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(23, 20), borders)
	var map = walker.walk(200)
	
	var player = Player.instance()
	ySort.add_child(player)
	player.position = Vector2(23, 20) * 32
	player.get_node("RemoteTransform2D").set_remote_node("../../../Camera2D")
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end() * 32
	exit.connect("leaving_level", self, "reload_level")
	walker.queue_free()
	for location in map:
		wallTileMap.set_cellv(location, -1)
		dirtPathTileMap.set_cellv(location, -1)
		
	dirtPathTileMap.update_bitmask_region(borders.position, borders.end)
	wallTileMap.update_bitmask_region(borders.position, borders.end)
	
	place_enemies(player, map)
	place_objects(map)
func reload_level():
	LevelStats.current_level += 1
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("restart"):
		PlayerStats.health = PlayerStats.max_health
		reload_level()
	if event.is_action_pressed("pickup"):
		PlayerStats.health = PlayerStats.max_health
func create_enemies(enemy):
	enemies.append(enemy.position)
	
func place_enemies(player, map):
	var can_place_enemy = true
	for location in map:
		can_place_enemy = true
		if randf() < 0.1 and enemies.size() < num_of_enemies:
			if (location * 32).distance_to(player.position) > 128:
				for enemy in enemies:
					if (location * 32).distance_to(enemy) < 80:
						can_place_enemy = false
				if can_place_enemy:
					var new_enemy = AllEnemies.get_enemy().instance()
					ySort.add_child(new_enemy)
					new_enemy.position = location * 32
					create_enemies(new_enemy)
					new_enemy.connect("died", self, "enemy_died")
					new_enemy.get_node("WanderController").start_position = (location * 32) + Vector2(8, 8)

func create_object(object_pos):
	objects.append(object_pos)

func place_objects(map):
	var can_place_object = true
	for location in map:
		can_place_object = true
		if randf() < 0.2:
			var object_pos = 1
			var new_object = AllObjects.get_object().instance()
			
			if new_object.name == "Tree" or new_object.name == "Bush":
				if randf() < 0.5:
					object_pos = (location * 32) + Vector2(14, randi() % 16 + 1)
				else:
					object_pos = (location * 32) + Vector2(20, randi() % 16 + 1)
			elif new_object.name == "Grass":
				object_pos = (location * 32) + Vector2(randi() % 16 + 1, randi() % 16 + 1)
			
			for object in objects:
				if object_pos.distance_to(object) < 32:
					can_place_object = false
			if can_place_object:
				ySort.add_child(new_object)
				new_object.position = object_pos
				create_object(object_pos)
			
func enemy_died(enemy_pos):
	var current_enemies = get_tree().get_nodes_in_group("Enemies").size()
	var chest_depreciation = 1
	if num_of_chests > 0:
		chest_depreciation = 20
	if current_enemies <= num_of_enemies / 2:
		chest_spawn_chance = 0.1 / num_of_enemies / chest_depreciation
		
	if randf() <= chest_spawn_chance or current_enemies - 1 == 0 and num_of_chests == 0:
		num_of_chests += 1
		if num_of_chests <= 2:
			spawn_chest(enemy_pos)
			
func spawn_chest(enemy_pos):
	var chest = Chest.instance()
	ySort.call_deferred("add_child", chest)
	chest.call_deferred("set", "global_position", enemy_pos)
