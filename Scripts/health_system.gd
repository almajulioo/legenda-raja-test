extends Node
class_name HealthSystem
var max_health: int 
var health: int = clamp(max_health, 0, max_health)
var heal_potion: int = 3
var invulnerable = false
var last_health : int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = clamp(get_parent().startingHealth, 0, get_parent().startingHealth)
	max_health = health
	last_health = health
	print("Starting health = " + str(health))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("heal") and heal_potion > 0 and health < 5:
		heal_potion -= 1
		health = clamp(health + 3, 0, max_health)
		last_health = health
		print("Health = " + str(health))
	#if Input.is_action_just_pressed("decrease_health") and not invulnerable:
		#health = clamp(health - 1, 0, 5)
		#print("Health = " + str(health))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < last_health and not invulnerable:
		invulnerable_time()

func invulnerable_time():
	invulnerable = true
	last_health = health
	$Timer.start(1)



func _on_timer_timeout() -> void:
	invulnerable = false

func is_dead():
	if health <= 0:
		return true
