extends Node2D

const Player = preload("res://Player/Player.tscn")
const Exit = preload("res://ExitDoor.tscn")

var borders = Rect2(1, 1, 46, 41)

onready var wallTileMap = $WallTileMap
onready var dirtPathTileMap = $DirtPathTileMap
onready var camera2D = $Camera2D

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(23, 20), borders)
	var map = walker.walk(200)
	
	var player = Player.instance()
	add_child(player)
	player.position = Vector2(23, 20) * 32
	player.get_node("RemoteTransform2D").set_remote_node("../../Camera2D")
	
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

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
