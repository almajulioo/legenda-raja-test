extends CharacterBody2D
class_name Boss_Air

# What state the turret is in
enum BossState {
	Attacking,
	Walking,
	Roar,
	Transform,
	Tornado,
	Dead,
}
@onready var animated_sprite_2d: BossAnimationController = $AnimatedSprite2D
@onready var player : Player = get_node("../Player")
@onready var bossHealth : BossHealthSystem = $HealthSystem
@onready var flash_animation = $AnimatedSprite2D/FlashAnimation
@onready var freeze_manager = $"../FreezeManager"
@onready var projectile_scene = preload("res://Boss/Air/peluru.tscn")
@onready var circle_scene = preload("res://Boss/Air/circle.tscn")
@onready var healthbar: ProgressBar = $CanvasLayer/Healthbar


var audio_player = AudioStreamPlayer2D.new()
var kena_hit_sound = "res://Assets/Sound/SFX MONSTER AIR/boss air kena hit khusus.mp3"
var proyektil_air_sound = "res://Assets/Sound/SFX MONSTER AIR/Proyektil air.mp3"
var roar_sound = "res://Assets/Sound/SFX MONSTER AIR/skill slow hempasan air.mp3"
var transform_sound = "res://Assets/Sound/SFX MONSTER AIR/revisi perubahan pusaran.mp3"
var dead_sound = "res://Assets/Sound/SFX MONSTER AIR/revisi boss air mati.mp3"

var isDead: bool = false
var canShoot: bool = true
var transformed: bool = false
var canShootCircle: bool = true
var canRoar: bool = false

var current_state: BossState = BossState.Walking
var state_change_timer: float = 0.0
var SPEED = 12000
var startingHealth = 50
var random_move_time = 1 # Time in seconds to pick a new random direction
var move_timer = 0.0
var punching : int = 0
var direction = Vector2()
var circleShootCount = 0

func _ready():
	healthbar.init_health(startingHealth)

func change_state(new_state: BossState) -> void:
	current_state = new_state
	
	
# Count down the timers and transition states when appropriate
func _physics_process(delta: float) -> void:
	if freeze_manager.check_if_frozen():
		return
	
	if bossHealth.is_dead():
		change_state(BossState.Dead)
	

	
	if circleShootCount == 5 and transformed == true:
		change_state(BossState.Transform)
		circleShootCount = 0
	
	if is_on_wall():
		move_timer = 0.0
	move_timer -= delta
	
	if move_timer <= 0.0:
		var dir_to_player = global_position - player.global_position  # Direction from enemy to player
		var random_angle = randf_range(0, 2 * PI)  # Pick a random angle
		direction = dir_to_player.rotated(random_angle).normalized()  # Move away from player with random variation
		move_timer = random_move_time
	velocity = direction * SPEED * delta
	if velocity.x > 0 and isDead == false:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0 and isDead == false:
		animated_sprite_2d.flip_h = true
	match current_state:
		BossState.Walking:
			animated_sprite_2d.play('idle')
			if canRoar:
				change_state(BossState.Roar)
			elif canShoot:
				shoot_projectile()
				canShoot = false
				$TimerCanShoot.start()
		BossState.Roar:
			velocity = Vector2.ZERO
			if canRoar:
				animated_sprite_2d.play("roar")
				canRoar = false
				$TimerCanRoar.start()
		BossState.Transform:
			if transformed == false: 
				animated_sprite_2d.play("transform")
				play_sound(load(transform_sound))
			else:
				animated_sprite_2d.play("transform_back")
		BossState.Tornado:
			$CombatSystem/BossBodyHitbox/CollisionShape2D.disabled = true
			animated_sprite_2d.play("tornado")
			velocity = Vector2.ZERO
			if canShootCircle:
				shoot_projectile_circle()
				canShootCircle = false
				$TimerCanShootCircle.start()
		BossState.Dead:
			if isDead == false:
				isDead = true
				animated_sprite_2d.play("dead")
				play_sound(load(dead_sound))
				velocity = Vector2.ZERO
	
	
	if isDead == false:   
		move_and_slide()

func take_damage(damage : int):
	flash_animation.play("flash")
	play_sound(load(kena_hit_sound))
	for i in (damage):
		bossHealth.health = clamp(bossHealth.health - 1, 0, bossHealth.max_health)
		healthbar.health = bossHealth.health
		if bossHealth.health == 20 or bossHealth.health == 35 and transformed == false:
			freeze_manager.apply_freeze()
			change_state(BossState.Transform)
	print("Health = " + str(bossHealth.health))

func shoot_projectile():
	var freq = 2
	var delay = 0.2
	
	for i in range(freq):
		play_sound(load(proyektil_air_sound))
		var projectile = projectile_scene.instantiate()  # Create the projectile instance
		get_parent().add_child(projectile)  # Add the projectile to the scene
		projectile.position = position + direction * 10  # Shoot from the boss's current position
		var dir_to_player = player.position - position  # Direction to player
		projectile.direction = dir_to_player.normalized() # Set the projectile's direction
		await get_tree().create_timer(delay).timeout

func spawn_circle():
	var circle = circle_scene.instantiate()
	get_parent().add_child(circle)
	play_sound(load(roar_sound))
	circle.position = position + direction * 10
	circle.animation_player.play("air")

func shoot_projectile_circle():
	var start_angle = 0.0  # Optional: Use an offset to rotate the whole pattern
	var base_num_projectiles = 8  # Base number of projectiles (can adjust based on circleShootCount)
	var angle_step
	var num_projectiles
	if circleShootCount % 2 == 0:
		num_projectiles = base_num_projectiles
	else:
		num_projectiles = base_num_projectiles + 6  # Add more projectiles to fill gaps in odd circles
	angle_step = 2 * PI / num_projectiles  
	play_sound(load(proyektil_air_sound))
	
	for i in range(num_projectiles):
		var angle = start_angle + (i * angle_step)  # Calculate the angle for each projectile
		var projectile = projectile_scene.instantiate()  # Create the projectile instance
		get_parent().add_child(projectile)  # Add the projectile to the scene
		# Set the direction of the projectile to point in the calculated angle
		var dir = Vector2(cos(angle), sin(angle))  # Convert angle to a direction vector
		projectile.direction = dir  # Set the direction of the projectile
		# Set the projectile's position slightly in front of the boss
		projectile.global_position = global_position + direction * 10  # Offset position slightly
	circleShootCount += 1

func play_sound(sound : AudioStream):
	audio_player.stream = sound
	audio_player.max_distance = 10000
	audio_player.attenuation = 0
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		change_state(BossState.Walking)

func _on_timer_can_shoot_timeout() -> void:
	canShoot = true

func _on_timer_can_shoot_circle_timeout() -> void:
	canShootCircle = true

func _on_timer_can_roar_timeout() -> void:
	canRoar = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "transform":
		transformed = true
		change_state(BossState.Tornado)
	if animated_sprite_2d.animation == "transform_back":
		transformed = false
		$CombatSystem/BossBodyHitbox/CollisionShape2D.disabled = false
		change_state(BossState.Walking)
	if animated_sprite_2d.animation == "roar":
		spawn_circle()
		player.slowed()
		change_state(BossState.Walking)
		
	if animated_sprite_2d.animation == "dead":
		queue_free()
	
