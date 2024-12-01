extends Area2D

@onready var player : Player = get_node("../Player")
@onready var animation_player = $AnimatedSprite2D
@onready var timerCrack = $TimerCrackStill
var speed : float = 400
var direction : Vector2 
var isMove = false
var isMoveTwo = false

func _physics_process(delta):
	_new_frame()

func _new_frame():
	var frame_count = 3
	var c_frame = $AnimatedSprite2D.get_frame()
	$CollisionPunch1.disabled = true
	$CollisionPunch2.disabled = true
	$CollisionPunch3.disabled = true
	if c_frame == 0:
		$CollisionPunch1.disabled = false
	elif c_frame == 1:
		$CollisionPunch2.disabled = false
		if isMove == false:
			position.y += 20
			isMove = true
	elif c_frame == 2:
		if isMoveTwo == false:
			position.y += 20
			isMoveTwo = true
		$CollisionPunch3.disabled = false

func _on_area_entered(area: Area2D) -> void:
	if area.name == "BodyHitbox":
		player.take_damage(2)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation_player.animation == "punchground":
		queue_free()
