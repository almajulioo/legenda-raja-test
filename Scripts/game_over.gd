extends Control

func _ready():
	self.z_index = 100
	get_tree().paused = true

func _on_credits_button_button_up() -> void:
	pass # Replace with function body.

func _on_exit_button_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_try_button_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
