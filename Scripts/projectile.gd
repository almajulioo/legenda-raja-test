extends Area2D

var speed : float = 200
var direction : Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
		rotation = direction.angle()

func _physics_process(delta):
	position += speed * direction * delta

func play(animation_name = "Laser"):
	$AnimatedSprite2D.play(animation_name)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
