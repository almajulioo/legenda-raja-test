extends Skill
class_name Siger

func _init(target):
	cooldown = 60.0
	texture = preload("res://Assets/Artefak dan Efek/Artefak/Siger.png")
	sound = preload("res://Assets/Sound/SFX PLAYER-HERO/shield.mp3")
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.active_shield(sound)
