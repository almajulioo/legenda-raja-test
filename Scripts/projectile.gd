extends Area2D

@onready var player : Player = get_node("../Player")

var laser_dmg = 1
var crack_dmg = 5
var move : bool = true
var speed : float = 600
var direction : Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
		rotation = direction.angle()
var crack_kena_sound = "res://Assets/Sound/SFX PLAYER-HERO/ground stomp kena monster.mp3"
var laser_kena_sound = "res://Assets/Sound/SFX PLAYER-HERO/laser hero kena monster batu.mp3"

func _physics_process(delta):
	if move: 
		position += speed * direction * delta

func play(animation_name):
	if animation_name == "Laser":
		move = true
		$AnimatedSprite2D.position = Vector2(0, 0)
		$AnimatedSprite2D.scale = Vector2(1, 1)
		$Laser/LaserCollision.disabled = false
		$Crack/CrackCollision.disabled = true
		$".".z_index = 0
	elif animation_name == "GroundCrack":
		move = false
		$AnimatedSprite2D.position = Vector2(8, 50)
		$AnimatedSprite2D.scale = Vector2(4.047, 3.828)
		$Laser/LaserCollision.disabled = true
		$Crack/CrackCollision.disabled = false
		$".".z_index = -1
		
	$AnimatedSprite2D.play(animation_name)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_crack_area_entered(area: Area2D) -> void:
	if area.name == "BossBodyHitbox":
		var boss = area.get_parent().get_parent()
		player.play_sound(load(crack_kena_sound))
		boss.take_damage(crack_dmg)

func _on_laser_area_entered(area: Area2D) -> void:
	if area.name == "BossBodyHitbox":
		var boss = area.get_parent().get_parent()
		player.play_sound(load(laser_kena_sound))
		boss.take_damage(laser_dmg)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "GroundCrack":
		$Crack/CrackCollision.disabled = true
