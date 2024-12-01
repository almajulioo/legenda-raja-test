extends Control

var isCredits : bool = false

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_credits_button_button_up() -> void:
	isCredits = true
	$ColorRect.visible = true
	$Panel.visible = true
	$AnimationPlayer.play("credits")

func _process(delta: float) -> void:
	if isCredits and Input.is_action_just_pressed("basic_attack"):
		isCredits = false
		$AnimationPlayer.play_backwards("credits")
		
		#$ColorRect.visible = false
		#$Panel.visible = false

func _on_exit_button_button_up() -> void:
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if isCredits == false:
		$ColorRect.visible = false
		$Panel.visible = false
