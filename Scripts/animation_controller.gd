extends AnimatedSprite2D

class_name AnimationController

func play_movement_animation(velocity:Vector2):
	if velocity.x > 0:
		flip_h = false
		play("walk")
	elif velocity.x < 0:
		flip_h = true
		play("walk")
	
	if velocity.y != 0:
		play("walk")
	
func play_idle_animation():
	play("idle")

func play_dash_animation():
	play("dash")	

	
	

	
