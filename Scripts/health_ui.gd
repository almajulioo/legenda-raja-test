extends CanvasLayer
@onready var health_system: HealthSystem = $"../HealthSystem"
@onready var count: Label = $Control/TextureButton/Count

var max_heal : int = 3
var max_health : int = 5
var max_shield : int = 3 

# Declare variables for filled and empty heart textures
var filled_heart_texture : Texture
var empty_heart_texture : Texture
var shield_texture : Texture

# List to hold the heart icons
var heart_icons = []
var shield_icons = []

func _ready():
	
	# Load the filled and empty heart textures
	filled_heart_texture = preload("res://Assets/Health dan Shield/Health-Full.png")  # Replace with your filled heart image path
	empty_heart_texture = preload("res://Assets/Health dan Shield/Health-Empty.png")    # Replace with your empty heart image path
	shield_texture = preload("res://Assets/Health dan Shield/Shield-Full.png")
	# Initialize heart icons and add them to the HBoxContainer
	for i in range(max_health):
		var heart = TextureRect.new()  
		heart_icons.append(heart)  
		$Control/HBoxContainer.add_child(heart) 
		 
	for i in range(max_shield):
			var shield = TextureRect.new()  
			shield_icons.append(shield)  
			$Control/HBoxContainer.add_child(shield)  
	
	count.text = str(max_heal)
	

func _process(float):
	update_health(health_system.health) 
	update_shield(health_system.shield)
	update_heal_potion(health_system.heal_potion)
	
# Update the heart UI when health changes
func update_health(current_health: int):
	for i in range(max_health):
		if i < current_health:
			heart_icons[i].texture = filled_heart_texture  # Show filled heart
		else:
			heart_icons[i].texture = empty_heart_texture  # Show empty heart

func update_shield(current_shield : int):
	for i in range(max_shield):
		if i < current_shield:
			shield_icons[i].texture = shield_texture
		else:
			shield_icons[i].texture = null

func update_heal_potion(current_heal_potion : int):
	count.text = str(current_heal_potion)
	if current_heal_potion <= 0:
		$Control/TextureButton/Panel.visible = true
	else:
		$Control/TextureButton/Panel.visible = false

# Set the player's health (this is a function you can call to change health)
#func set_health(health: int):
	#current_health = clamp(health, 0, max_health)  # Ensure health is between 0 and max_health
	#update_health()  # Update the heart UI based on new health
