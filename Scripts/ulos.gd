extends Skill
class_name Ulos

func _init(target):
	cooldown = 5.0
	texture = preload("res://Assets/Artefak dan Efek/Artefak/BajuUlos.png")
	sound = preload("res://Assets/Sound/SFX PLAYER-HERO/newesrt ground stomp.mp3")
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.single_shot("GroundCrack", sound)
