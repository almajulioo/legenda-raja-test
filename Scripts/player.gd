extends CharacterBody2D

class_name Player
@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D

var SPEED = 30000
var direction : Vector2
var canDash = true
var dashing = false

func _physics_process(delta: float) -> void:
	if not dashing:
		direction = Input.get_vector("left", "right", "up", "down")
		
	if direction: 
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	
	if not dashing and Input.is_action_just_pressed("dash") and direction != Vector2.ZERO and canDash:
		dashing = true
		canDash = false
		SPEED = SPEED * 8
		$TimerDashing.start(0.1)
		$TimerCanDash.start(1)
	
	if velocity != Vector2.ZERO:
		if is_on_wall() and velocity.y == 0:
			animated_sprite_2d.play_idle_animation()
		elif (is_on_ceiling() or is_on_floor()) and velocity.x == 0:
			animated_sprite_2d.play_idle_animation()	
		else:
			animated_sprite_2d.play_movement_animation(velocity)
		
	else:
		animated_sprite_2d.play_idle_animation()
	
	move_and_slide()

func _on_timer_dashing_timeout():
	$TimerDashing.stop()
	dashing = false
	SPEED = 30000

func _on_timer_can_dash_timeout() -> void:
	$TimerCanDash.stop()
	canDash = true
