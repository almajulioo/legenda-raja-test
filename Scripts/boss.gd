extends CharacterBody2D

class_name Boss
@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var left_collision: CollisionShape2D = $CombatSystem/WeaponHitbox/LeftCollision
@onready var right_collision: CollisionShape2D = $CombatSystem/WeaponHitbox/RightCollision
@onready var body_hitbox_collision: CollisionShape2D = $CombatSystem/BodyHitbox/CollisionShape2D
@onready var bossHealth : HealthSystem = $HealthSystem

var SPEED = 10000
var direction : Vector2
var dBoss : Vector2
var dashing = false
var idle = true
var chase = false
var canAttack = true
var attacking = false
var inRange = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bossHealth.health = clamp(20, 0, 20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if has_node("../Player"):
		var boss = get_node("../Boss")
		var player = get_node("../Player")
		dBoss = player.position - boss.position
		if attacking and not inRange: 
			direction = (player.position - boss.position).normalized()
		elif not attacking and chase:
			direction = (player.position - boss.position).normalized()
		else: 
			direction = Vector2.ZERO
		
		if direction: 
			velocity = direction * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			velocity.y = move_toward(velocity.y, 0, SPEED * delta)
			
		
	if attacking and canAttack:
		$TimerCanAttack.start(2) 
		canAttack = false
		animated_sprite_2d.play_attack_animation(dBoss)
	elif chase:
		animated_sprite_2d.play_movement_animation(velocity)
	else:
		animated_sprite_2d.play_idle_animation()
		
	move_and_slide()


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true
		idle = false
	

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false
		idle = true
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		attacking = true
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		attacking = false


func _on_timer_can_attack_timeout() -> void:
	canAttack = true
	


func _on_body_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inRange = true
		

func _on_body_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inRange = false
