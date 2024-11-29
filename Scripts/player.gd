extends CharacterBody2D

class_name Player
@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var left_collision: CollisionShape2D = $CombatSystem/WeaponHitbox/LeftCollision
@onready var right_collision: CollisionShape2D = $CombatSystem/WeaponHitbox/RightCollision
@onready var body_hitbox_collision: CollisionShape2D = $CombatSystem/BodyHitbox/CollisionShape2D
@onready var playerHealth : HealthSystem = $HealthSystem
@export var projectile_node : PackedScene

var DEF_SPEED = 10000
var SPEED = DEF_SPEED
var direction : Vector2
var canDash = true
var dashing = false
var idle = true
var walking = false
var attacking = false

func _physics_process(delta: float) -> void:
	if not dashing:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
		
	if direction: 
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	
	if not dashing and Input.is_action_just_pressed("dash") and direction != Vector2.ZERO and canDash:
		dashing = true
		canDash = false
		SPEED = SPEED * 8
		animated_sprite_2d.play_dash_animation()
		$TimerDashing.start(0.1)
		$TimerCanDash.start(1)
	
	if dashing:
		body_hitbox_collision.disabled = true
	else:
		body_hitbox_collision.disabled = false
		
	if velocity != Vector2.ZERO and not attacking:
		if is_on_wall() and velocity.y == 0:
			animated_sprite_2d.play_idle_animation()
		elif (is_on_ceiling() or is_on_floor()) and velocity.x == 0:
			animated_sprite_2d.play_idle_animation()	
		else:
			animated_sprite_2d.play_movement_animation(velocity)
		
	elif velocity == Vector2.ZERO and not attacking:
		animated_sprite_2d.play_idle_animation()
	move_and_slide()

#func _input(event):
	#if Input.is_action_just_pressed("basic_attack"):
		#attacking = true
		#animated_sprite_2d.play_attack_animation(direction)
	
func _on_timer_dashing_timeout():
	$TimerDashing.stop()
	dashing = false
	SPEED = DEF_SPEED

func _on_timer_can_dash_timeout() -> void:
	$TimerCanDash.stop()
	canDash = true
	

#func _on_animated_sprite_2d_animation_finished() -> void:
	#attacking = false
	#left_collision.disabled = true
	#right_collision.disabled = true
	

func _on_left_weapon_sprite_animation_finished() -> void:
	attacking = false
	left_collision.disabled = true
	right_collision.disabled = true
	$CombatSystem/LeftWeaponSprite.visible = false

func _on_right_weapon_sprite_animation_finished() -> void:
	attacking = false
	left_collision.disabled = true
	right_collision.disabled = true
	$CombatSystem/RightWeaponSprite.visible = false

func single_shot
