extends Control




func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_credits_button_button_up() -> void:
	pass # Replace with function body.


func _on_exit_button_button_up() -> void:
	get_tree().quit()
