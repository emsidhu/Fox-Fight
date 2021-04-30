extends Node2D

const Player = preload("res://Player/Player.tscn")
const Exit = preload("res://ExitDoor.tscn")
const Bat = preload("res://Enemies/Bat.tscn")
const Grass = preload("res://World/Grass.tscn")

var borders = Rect2(1, 1, 46, 41)
var enemies = []
var num_of_enemies = 10
var level_num = 0

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
func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("restart"):
		reload_level()

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
					var new_enemy = Bat.instance()
					ySort.add_child(new_enemy)
					new_enemy.position = location * 32
					create_enemies(new_enemy)
					new_enemy.connect("died", self, "spawn_chest")
					new_enemy.get_node("WanderController").start_position = location * 32

func spawn_chest(enemy_pos):
	if get_tree().get_nodes_in_group("Enemies").size() <= num_of_enemies / 2:
			var grass = Grass.instance()
			ySort.call_deferred("add_child", grass)
			grass.call_deferred("set", "position", enemy_pos)

					
