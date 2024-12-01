extends Node2D

class_name CombatSystem

@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
@onready var player: Player = $".."
@onready var left_collision: CollisionShape2D = $WeaponHitbox/LeftCollision
@onready var right_collision: CollisionShape2D = $WeaponHitbox/RightCollision
@onready var left_weapon_sprite: AnimatedSprite2D = $LeftWeaponSprite
@onready var right_weapon_sprite: AnimatedSprite2D = $RightWeaponSprite

var canAttack = true

func _input(_event):
	if Input.is_action_just_pressed("basic_attack") and canAttack and not player.dashing:
		$"../TimerCanAttack".start()
		canAttack = false
		player.attacking = true
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
