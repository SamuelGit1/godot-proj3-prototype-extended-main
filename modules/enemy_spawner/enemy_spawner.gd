extends Node3D

@export var enemy_scene: PackedScene
@export var floor_node: CSGBox3D
@export var spawn_interval = 3.0
@export var spawn_distance_from_edge = 1.0

func _on_timer_timeout() -> void:
	spawn_enemy_at_edge()


func spawn_enemy_at_edge():
	if not enemy_scene or not floor_node:
		return
	
	# Get floor dimensions
	var floor_size = floor_node.size
	var half_width = floor_size.x / 2
	var half_depth = floor_size.z / 2
	
	# Randomly select which edge to spawn on (0=top, 1=right, 2=bottom, 3=left)
	var edge = randi() % 4
	var spawn_pos = Vector3()
	
	match edge:
		0: # Top edge (negative Z)
			spawn_pos = Vector3(
				randf_range(-half_width + spawn_distance_from_edge, half_width - spawn_distance_from_edge),
				0,
				- half_depth + spawn_distance_from_edge
			)
		1: # Right edge (positive X)
			spawn_pos = Vector3(
				half_width - spawn_distance_from_edge,
				0,
				randf_range(-half_depth + spawn_distance_from_edge, half_depth - spawn_distance_from_edge)
			)
		2: # Bottom edge (positive Z)
			spawn_pos = Vector3(
				randf_range(-half_width + spawn_distance_from_edge, half_width - spawn_distance_from_edge),
				0,
				half_depth - spawn_distance_from_edge
			)
		3: # Left edge (negative X)
			spawn_pos = Vector3(
				- half_width + spawn_distance_from_edge,
				0,
				randf_range(-half_depth + spawn_distance_from_edge, half_depth - spawn_distance_from_edge)
			)
	
	# Adjust for floor's global position
	spawn_pos += floor_node.global_position
	
	# Create and position enemy
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = spawn_pos + Vector3(0, 1, 0) # Adjust height if needed


func _on_player_died(is_dead: bool) -> void:
	if (is_dead):
		$Timer.stop()
