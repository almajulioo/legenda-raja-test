extends Area2D

@onready var player : Player = get_node("../Player")
@onready var animation_player = $AnimatedSprite2D
var speed : float = 400
var direction : Vector2 

func _physics_process(delta):
	rotation = direction.angle()
	position += speed * direction * delta


func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.take_damage(1)
