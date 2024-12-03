extends Node

@onready var player : Player = get_node("../Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AnimatedSprite2D.flip_h == true:
		$RightCollision/CollisionPolygon2D.disabled = true
		$LeftCollision/CollisionPolygon2D.disabled = false
	else:
		$RightCollision/CollisionPolygon2D.disabled = false
		$LeftCollision/CollisionPolygon2D.disabled = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.take_damage(1)
