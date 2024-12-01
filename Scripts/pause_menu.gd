extends Control
var options : bool = false

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	if options:
		$AnimationPlayer2.play_backwards("options")
		options = false
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func testEsc():
	
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()

func _process(_delta: float) -> void:
	testEsc()

func _on_resume_button_up() -> void:
	resume()


func _on_options_button_up() -> void:
	if options == false:
		$AnimationPlayer.play("options")
		options = true
	else:
		$AnimationPlayer.play_backwards("options")
		options = false


func _on_quit_button_up() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
