extends ProgressBar


func _ready():
	value = 100.0 # Set initial health value
	max_value = 100.0 # Set maximum health value
	visible = false # Make sure the health bar is visible

func _on_enemy_health_changed(new_hp: float, max_hp: float) -> void:
	# Update the health bar value based on the enemy's health
	value = new_hp
	max_value = max_hp
	visible = value != max_value # Show or hide the health bar based on health status
	
	# Change the color of the health bar based on the current health percentage
	var health_percentage = new_hp / max_hp
	if health_percentage > 0.5:
		self.add_theme_color_override("fg_color", Color(0, 1, 0)) # Green for healthy
	elif health_percentage > 0.2:
		self.add_theme_color_override("fg_color", Color(1, 1, 0)) # Yellow for caution
	else:
		self.add_theme_color_override("fg_color", Color(1, 0, 0)) # Red for danger
