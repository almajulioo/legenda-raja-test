extends Node2D

class_name CombatSystem

@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
@onready var player: Player = $".."
@onready var left_collision: CollisionShape2D = $WeaponHitbox/LeftCollision
@onready var right_collision: CollisionShape2D = $WeaponHitbox/RightCollision
@onready var left_weapon_sprite: AnimatedSprite2D = $LeftWeaponSprite
@onready var right_weapon_sprite: AnimatedSprite2D = $RightWeaponSprite

var suaraTebasan = [
	"res://Assets/Sound/SFX PLAYER-HERO/new tebasan kena 1.mp3",
	"res://Assets/Sound/SFX PLAYER-HERO/new tebasan kena 2.mp3",
	"res://Assets/Sound/SFX PLAYER-HERO/new tebasan kena 3.mp3",
]
var currentTebasan = 0
var canAttack = true

func _input(_event):
	if not player.playerHealth.is_dead() and Input.is_action_just_pressed("basic_attack") and canAttack and not player.dashing:
		$"../TimerCanAttack".start()
		canAttack = false
		player.attacking = true
		player.play_sound(load(suaraTebasan[currentTebasan]))
		currentTebasan += 1
		if currentTebasan == 3:
			currentTebasan = 0
		
		var left_or_right = get_global_mouse_position() - player.position 
		if left_or_right.x > 0:
			animated_sprite_2d.flip_h = false
		elif left_or_right.x < 0:
			animated_sprite_2d.flip_h = true
		print(left_or_right.x)
		if animated_sprite_2d.flip_h:
			left_weapon_sprite.play("attack")
			left_weapon_sprite.visible = true
			left_collision.disabled = false
		else:
			right_weapon_sprite.play("attack")
			right_weapon_sprite.visible =true
			right_collision.disabled = false



func _on_weapon_hitbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "BossBodyHitbox":
		var boss = area.get_parent().get_parent()
		print("Darah Boss:")
		boss.take_damage(1)


func _on_timer_can_attack_timeout() -> void:
	canAttack = true
