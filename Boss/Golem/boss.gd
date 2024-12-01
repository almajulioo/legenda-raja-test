extends CharacterBody2D
class_name Boss

# What state the turret is in
enum BossState {
	Idle,
	Attacking,
	Chasing,
	Dash,
	Skill1,
	Dead,
}
@onready var animated_sprite_2d: BossAnimationController = $AnimatedSprite2D
@onready var player : Player = get_node("../Player")
@onready var bossHealth : BossHealthSystem = $HealthSystem
@onready var flash_animation = $AnimatedSprite2D/FlashAnimation
@onready var freeze_manager = $"../FreezeManager"

# Preload fang projectile or attack animation
var fang_attack_scene = preload("res://Boss/Golem/skill1.tscn")  


var canAttack : bool = true
var attacking : bool = false
var canUseSkillOne : bool = false
var isDead: bool = false
var dashing: bool = false
var canDash: bool = true

var current_state: BossState = BossState.Chasing
var state_change_timer: float = 0.0
var SPEED = 15000
var startingHealth = 50

var punching : int = 0


func change_state(new_state: BossState) -> void:
	current_state = new_state
	
func _physics_process(delta: float) -> void:
	pass
	
# Count down the timers and transition states when appropriate
func _process(delta: float) -> void:
	if freeze_manager.check_if_frozen():
		return
	
	if bossHealth.is_dead():
		change_state(BossState.Dead)
	
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED * delta
	if velocity.x > 0 and isDead == false:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0 and isDead == false:
		animated_sprite_2d.flip_h = true
	match current_state:
		BossState.Idle:
			animated_sprite_2d.play('idle')
		BossState.Chasing:
			animated_sprite_2d.play('idle')
			if canDash:
				change_state(BossState.Dash)
		BossState.Dash:
			if canDash:
				animated_sprite_2d.play("dash")
				$TimerCanDash.start()
				dashing = true
				canDash = false
				SPEED = 140000
		BossState.Attacking:
			if canUseSkillOne == true:
				change_state(BossState.Skill1)
			elif canAttack:
				$TimerCanAttack.start()
				$TimerAttacking.start(0.3)
				attacking = true
				canAttack = false
				animated_sprite_2d.play("attack")
				if velocity.x > 0:
					$CombatSystem/WeaponHitbox/RightCollision.disabled = false
				elif velocity.x < 0:
					$CombatSystem/WeaponHitbox/LeftCollision.disabled = false
		BossState.Skill1:
			if canUseSkillOne == true:
				$TimerAttacking.start(0.3)
				attacking = true
				$TimerSkill1.start()
				canUseSkillOne = false
				animated_sprite_2d.play("skill1")
		BossState.Dead:
			isDead = true
			animated_sprite_2d.play("dead")
	
	if attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	
	if position.distance_to(player.position) > 40 and isDead == false:   
		move_and_slide()


func effect():
	var spawn_count = 4  # Number of times to spawn the fang
	var spawn_gap = 100  # Distance gap between each spawn
	var fang = fang_attack_scene.instantiate()  
	var fang_sprite = fang.get_node("AnimatedSprite2D")  # Assuming AnimatedSprite2D is a child of the fang node
	get_parent().add_child(fang)  # Add fang to the scene
	fang_sprite.play("spike")  # Play the "spike" animation
	if velocity.x > 0:
		spawn_gap = 80
		fang_sprite.flip_h = false
	elif velocity.x < 0:
		spawn_gap = -80
		fang_sprite.flip_h = true

	for i in range(spawn_count):
		fang.position = position + Vector2(i * spawn_gap, 0)  # Offset position by 'spawn_gap'
		await get_tree().create_timer(0.2).timeout
		
	await get_tree().create_timer(1).timeout	
	fang_sprite.play("break")
	await get_tree().create_timer(1.2).timeout	
	fang.free()

func take_damage(damage : int):
	flash_animation.play("flash")
	bossHealth.health = clamp(bossHealth.health - damage, 0, bossHealth.max_health)
	print("Health = " + str(bossHealth.health))		

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		change_state(BossState.Chasing)

func _on_attacking_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not dashing:
		change_state(BossState.Attacking)

func _on_attacking_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$CombatSystem/WeaponHitbox/RightCollision.disabled = true
		$CombatSystem/WeaponHitbox/LeftCollision.disabled = true
		change_state(BossState.Chasing)
		
func _on_timer_can_attack_timeout() -> void:
	canAttack = true
	
func _on_timer_attacking_timeout() -> void:
	attacking = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if punching == 2:
		canUseSkillOne = true
		punching = 0
	if animated_sprite_2d.animation == "attack":
		$CombatSystem/WeaponHitbox/RightCollision.disabled = true
		$CombatSystem/WeaponHitbox/LeftCollision.disabled = true
		punching += 1
	if animated_sprite_2d.animation == "skill1":
		change_state(BossState.Attacking)
		effect()
	if animated_sprite_2d.animation == "dash":
		dashing = false
		SPEED = 15000
		change_state(BossState.Attacking)

func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.take_damage(1)

func _on_timer_can_dash_timeout() -> void:
	canDash = true
