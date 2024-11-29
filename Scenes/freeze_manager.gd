extends Node

var is_frozen = false  
var freeze_duration = 0.5 
var freeze_timer = 0.0  

func _process(delta):
	if is_frozen:
		freeze_timer -= delta
		if freeze_timer <= 0:
			is_frozen = false 


func apply_freeze():
	is_frozen = true
	freeze_timer = freeze_duration  

func check_if_frozen() -> bool:
	return is_frozen
