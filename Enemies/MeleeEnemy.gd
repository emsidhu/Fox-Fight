extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

export var ACCELERATION = 300
export var MAX_SPEED = 65
export var FRICTION = 200
export var SOFTPOWER = 400
export var TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

signal died(value)

func _ready():
	pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
		
		WANDER:
			go_to(wanderController.target_position, delta)
			seek_player()
			

			if wanderController.get_time_left() == 0 or global_position.distance_to(wanderController.target_position) <= TARGET_RANGE:
				update_wander()
			

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				go_to(player.global_position, delta)
			else:
				state = IDLE
			
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION*delta)
	knockback = move_and_slide(knockback)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SOFTPOWER
	velocity = move_and_slide(velocity)
	
func update_wander():
	pick_random_state([IDLE, WANDER, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
	
func go_to(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
func pick_random_state(state_list):
	state_list.shuffle()
	state = state_list.front()



func _on_Hurtbox_area_entered(area):
	hurtbox.create_hit_effect()
	stats.health -= area.damage
	knockback = area.knockback_vector * 160
	hurtbox.start_invincibility(0.4)

func create_death_effect():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Stats_no_health():
	emit_signal("died", global_position)
	create_death_effect()
	queue_free()
	




func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")



