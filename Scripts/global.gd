extends Node

var player_max_health := 100.0
var player_atk_dmg := 10.0
var is_boss_batu_defeated = false
var is_boss_air_defeated = false
var is_boss_bayangan_defeated = false

enum INPUT_TYPES {MNK, GAMEPAD}
static var INPUT_TYPE : INPUT_TYPES = INPUT_TYPES.MNK

#func _input(event: InputEvent) -> void:
	#if InputEvent == InputEventJoypadButton or InputEventJoypadMotion:
		#INPUT_TYPE = INPUT_TYPES.GAMEPAD
	#elif InputEvent == InputEventKey or InputEventMouseButton or InputEventMouseMotion:
		#INPUT_TYPE = INPUT_TYPES.MNK
	#print(INPUT_TYPE)
