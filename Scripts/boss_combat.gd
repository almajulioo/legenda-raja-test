extends Node2D

class_name BossCombat

@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
@onready var boss: Boss = $".."
@onready var left_collision: CollisionShape2D = $WeaponHitbox/LeftCollision
@onready var right_collision: CollisionShape2D = $WeaponHitbox/RightCollision
@onready var bossHealth : HealthSystem = $"../HealthSystem"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bossHealth.health = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss.attacking and boss.dBoss.x < 0 and boss.canAttack and $TimerAttacking.is_stopped():
		$TimerAttacking.start(0.3)
		left_collision.disabled = false
	elif boss.attacking and not boss.dBoss.x < 0 and boss.canAttack and $TimerAttacking.is_stopped():
		$TimerAttacking.start(0.3)
		right_collision.disabled = false
	#else:
		#left_collision.disabled = true
		#right_collision.disabled = true


func _on_timer_attacking_timeout() -> void:
	$TimerAttacking.stop()
	left_collision.disabled = true
	right_collision.disabled = true


func _on_weapon_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = get_node("../../Player")
		print("Darah Pemain : ")
		player.playerHealth.take_damage(1)
