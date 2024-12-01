extends Area2D

@onready var player : Player = get_node("../Player")
@onready var animation_player = $AnimatedSprite2D
var speed : float = 600
var direction : Vector2 
var canMove = false


func _physics_process(delta):
	if canMove:
		animation_player.flip_h = false
		rotation = direction.angle()
		position += speed * direction * delta
	else: 
		pass


func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.take_damage(1)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation_player.animation == "tangan":
		canMove = true
