extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var chargeTimer = $ChargeTimer
onready var chargeAnimationPlayer = $ChargeAnimationPlayer

export var ACCELERATION = 400
var MAX_SPEED = PlayerStats.speed
export(float) var ROLL_SPEED = MAX_SPEED * 1.5
export(float) var FRICTION = 400

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.RIGHT
var stats = PlayerStats
var damage = stats.damage
var is_charged = false


func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = Vector2.RIGHT

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state()
		
		ATTACK:
			attack_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/ChargeAttack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)

		
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		chargeTimer.start(0.5)
	
	if Input.is_action_just_released("attack"):
		chargeTimer.stop()
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		chargeTimer.stop()
		state = ROLL
		hurtbox.start_invincibility(0.48)
		if is_charged:
			damage /= 2
			is_charged = false
		
	if Input.is_action_just_pressed("restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		
func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()


	
func attack_state():
	velocity = Vector2.ZERO
	if is_charged == true:
		chargeAnimationPlayer.play("Uncharge")
		animationState.travel("ChargeAttack")
	else:
		animationState.travel("Attack")
	if Input.is_action_just_pressed("attack"):
		chargeTimer.start(0.5)
	
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	if is_charged:
		damage /= 2
		is_charged = false
	velocity = velocity/1.5
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
	if is_charged:
		damage /= 2
		is_charged = false


func _on_Hurtbox_area_entered(area):
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	stats.health -= area.damage
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	if area.is_in_group("MeleeEnemy") and not area.get_parent().is_in_group("Tutorial"):
		area.get_parent().knockback = position.direction_to(area.get_parent().position) * 160
	


func _on_Hurtbox_invincibility_started():
	if state != ROLL:
		blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_ChargeTimer_timeout():
	if Input.is_action_pressed("attack") and not is_charged:
		is_charged = true
		damage *= 2
		print(damage)
		chargeAnimationPlayer.play("Charge")
		

