extends CanvasLayer
@onready var health_system: HealthSystem = $"../HealthSystem"


var max_health: int = 5 

# Declare variables for filled and empty heart textures
var filled_heart_texture : Texture
var empty_heart_texture : Texture

# List to hold the heart icons
var heart_icons = []

func _ready():
	
	# Load the filled and empty heart textures
	filled_heart_texture = preload("res://Assets/Health dan Shield/Health-Full.png")  # Replace with your filled heart image path
	empty_heart_texture = preload("res://Assets/Health dan Shield/Health-Empty.png")    # Replace with your empty heart image path

	# Initialize heart icons and add them to the HBoxContainer
	for i in range(max_health):
		var heart = TextureRect.new()  # Create a new heart icon (TextureRect)
		heart_icons.append(heart)  # Add heart icon to the list
		$Control/HBoxContainer.add_child(heart)  # Add heart icon to the HBoxContainer
	

func _process(float):
	update_health(health_system.health)
	
# Update the heart UI when health changes
func update_health(current_health: int):
	for i in range(max_health):
		if i < current_health:
			heart_icons[i].texture = filled_heart_texture  # Show filled heart
		else:
			heart_icons[i].texture = empty_heart_texture  # Show empty heart

# Set the player's health (this is a function you can call to change health)
#func set_health(health: int):
	#current_health = clamp(health, 0, max_health)  # Ensure health is between 0 and max_health
	#update_health()  # Update the heart UI based on new health
