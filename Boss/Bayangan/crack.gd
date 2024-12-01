extends Area2D

@onready var player : Player = get_node("../Player")
@onready var animation_player = $AnimatedSprite2D
@onready var timerCrack = $TimerCrackStill
var speed : float = 400
var direction : Vector2 



func _physics_process(delta):
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.take_damage(2)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation_player.animation == "crack":
		$CollisionCrack.disabled = true
	if animation_player.animation == "clear":
		queue_free()
		
func _on_timer_crack_still_timeout() -> void:
	animation_player.play("clear")
