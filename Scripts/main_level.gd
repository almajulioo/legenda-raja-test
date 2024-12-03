extends Node2D

@onready var player: Player = $Player

var masuk_portal_sound = "res://Assets/Sound/SFX GAME/masuk ke portal.mp3"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_batu_body_entered(body: Node2D) -> void:
	if body is Player:
		player.onPortal = true
		player.play_sound(load(masuk_portal_sound))
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://level_batu.tscn")


func _on_portal_air_body_entered(body: Node2D) -> void:
	if body is Player:
		player.onPortal = true
		player.play_sound(load(masuk_portal_sound))
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://level_air.tscn")


func _on_portal_bayangan_body_entered(body: Node2D) -> void:
	if body is Player:
		player.onPortal = true
		player.play_sound(load(masuk_portal_sound))
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://level_bayangan.tscn")
