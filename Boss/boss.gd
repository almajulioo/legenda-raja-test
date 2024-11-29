extends CharacterBody2D
class_name Boss

# What state the turret is in
enum BossState {
	Idle,
	Attacking,
	Chasing,
	Skill1,
	Dead,
}
@onready var animated_sprite_2d: BossAnimationController = $AnimatedSprite2D
@onready var player : Player = get_node("../Player")
@onready var bossHealth : HealthSystem = $HealthSystem

var canAttack : bool = true
var attacking : bool = false
var canUseSkillOne : bool = false
var isDead: bool = false


var current_state: BossState = BossState.Attacking
var state_change_timer: float = 0.0
var SPEED = 24000
var startingHealth = 20

var punching : int = 0


func change_state(new_state: BossState) -> void:
	current_state = new_state
	
func _physics_process(delta: float) -> void:
	pass
	
# Count down the timers and transition states when appropriate
func _process(delta: float) -> void:
	if bossHealth.is_dead():
		change_state(BossState.Dead)
	
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED * delta
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
	match current_state:
		BossState.Idle:
			animated_sprite_2d.play('idle')
		BossState.Chasing:
			animated_sprite_2d.play('idle')
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
				$TimerSkill1.start()
				canUseSkillOne = false
				animated_sprite_2d.play("skill1")
		BossState.Dead:
			isDead = true
			animated_sprite_2d.play("dead")
	
	if attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	
	if position.distance_to(player.position) > 70 and isDead == false:   
		move_and_slide()


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		change_state(BossState.Chasing)

func _on_attacking_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
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
	if punching == 3:
		canUseSkillOne = true
		punching = 0
	if animated_sprite_2d.animation == "attack":
		$CombatSystem/WeaponHitbox/RightCollision.disabled = true
		$CombatSystem/WeaponHitbox/LeftCollision.disabled = true
		punching += 1
	if animated_sprite_2d.animation == "skill1":
		change_state(BossState.Attacking)

func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.playerHealth.take_damage(1)
		
