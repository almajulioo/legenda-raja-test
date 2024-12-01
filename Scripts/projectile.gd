extends Area2D

@onready var player : Player = get_node("../Player")

var speed : float = 300
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


func _on_area_entered(area: Area2D) -> void:
	var boss = $"../Node2D/Boss"
	if area.name == "BossBodyHitbox":
		print(boss)
		boss.take_damage(1)
		#print(player)
		
