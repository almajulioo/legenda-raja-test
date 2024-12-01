extends Skill
class_name Ulos

func _init(target):
	cooldown = 5.0
	texture = preload("res://Assets/Artefak dan Efek/Artefak/BajuUlos.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.single_shot("GroundCrack")
