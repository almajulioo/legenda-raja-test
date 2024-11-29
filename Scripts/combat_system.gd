extends Node2D

class_name CombatSystem

@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
@onready var player: Player = $".."
@onready var left_collision: CollisionShape2D = $WeaponHitbox/LeftCollision
@onready var right_collision: CollisionShape2D = $WeaponHitbox/RightCollision

func _input(event):
	if Input.is_action_just_pressed("basic_attack"):
		player.attacking = true
		animated_sprite_2d.play_attack_animation(player.velocity)
		if animated_sprite_2d.flip_h:
			left_collision.disabled = false
		else:
			right_collision.disabled = false
			


#func _on_weapon_hitbox_body_entered(body: Node2D) -> void:
	#if body.name == "Boss":
		

func _on_weapon_hitbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "BossBodyHitbox":
		var boss = get_node("../../Boss")
		print("Darah Boss:")
		boss.bossHealth.take_damage(1)
