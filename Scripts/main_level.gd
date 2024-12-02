extends Node2D

@onready var player = $Player
var masuk_portal_sound = "res://Assets/Sound/SFX GAME/masuk ke portal.mp3"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_batu_body_entered(body: Node2D) -> void:
	if body is Player:
		player.play_sound(load(masuk_portal_sound))
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://level_batu.tscn")


func _on_level_air_body_entered(body: Node2D) -> void:
	if body is Player:
		player.play_sound(load(masuk_portal_sound))
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://level_air.tscn")
 

func _on_level_bayangan_body_entered(body: Node2D) -> void:
	if body is Player:
		player.play_sound(load(masuk_portal_sound))
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://level_bayangan.tscn")
		
		
