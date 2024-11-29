extends Skill
class_name Siger

func _init(target):
	cooldown = 60.0
	texture = preload("res://Assets/Artefak dan Efek/Artefak/Siger.png")
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.active_shield()
