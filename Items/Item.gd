extends KinematicBody2D

var bounce = Vector2(20, -40)
export(float) var drop_speed = 200
var is_bouncing = true

onready var audioStreamPlayer = $AudioStreamPlayer
onready var itemBounceArea = $ItemBounce/ItemBounceArea
onready var playerDetectionZone = $PlayerDetectionZone
onready var itemCollision = $ItemCollision

func _ready():
	audioStreamPlayer.connect("finished", self, "queue_free")
	itemBounceArea.connect("area_entered", self, "stop_bounce")


func stop_bounce(area):
	if area.get_name() == "ItemCollision":
		is_bouncing = false
		bounce = Vector2.ZERO



func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_slide(bounce)
	if is_bouncing == true:
		bounce = bounce.move_toward(Vector2(12, 55), drop_speed * delta)



