extends Area3D

var target: CharacterBody3D
var speed = 20
var attack_power = 50

func _ready() -> void:
	# Lift the ball up by 1 unit in y-direction
	global_position += Vector3.UP


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target) or target.is_dead:
		queue_free()
		return
	
	var distance = target.global_position - global_position
	# `distance` represents the vector from the current position to the target's position.
	# For example, it could be something like (x: 10, y: 0, z: 50).

	var direction = distance.normalized()
	# `direction` is the normalized vector of `distance`, representing the direction
	# to the target as a unit vector. 
	# For example, it could be something like (x: 0.2, y: 0, z: 1.0).
	# Ultimately, we can calculate the angle to the target with trigonometry formula
	

	global_position += direction * speed * delta
	# Calculate rotation to face the direction of movement
	if direction != Vector3.ZERO:
		# Calculate yaw (horizontal rotation) using arctangent of X and Z components
		var yaw = atan2(direction.x, direction.z)
		# Calculate pitch (vertical tilt) using arcsine of negative Y component
		var pitch = asin(-direction.y)
		# Apply rotation (Z-component remains 0 to prevent rolling)
		rotation = Vector3(pitch, yaw, 0)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not body.is_dead:
		print("Hit enemy: ", body.name)
		body.take_hit(attack_power)
		queue_free()
