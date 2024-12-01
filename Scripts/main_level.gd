extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_level_batu_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://level_batu.tscn")


func _on_level_air_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://level_air.tscn")


func _on_level_bayangan_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://level_bayangan.tscn")
