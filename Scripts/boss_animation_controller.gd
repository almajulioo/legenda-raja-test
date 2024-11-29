extends AnimatedSprite2D

class_name BossAnimationController

func play_movement_animation(velocity:Vector2):
	if velocity.x > 0:
		flip_h = false
		play("idle")
	elif velocity.x < 0:
		flip_h = true
		play("idle")
	
	if velocity.y != 0:
		play("idle")
	
func play_idle_animation():
	play("idle")

func play_attack_animation(velocity:Vector2):
	if velocity.x > 0:
		flip_h = false
	elif velocity.x < 0:
		flip_h = true
	play("attack")
	
func play_skill1_animation(velocity:Vector2):
	if velocity.x > 0:
		flip_h = false
	elif velocity.x < 0:
		flip_h = true
	play("skill1")
	

	
