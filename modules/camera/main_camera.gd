extends Camera3D

@export var target: CharacterBody3D
@export var follow_speed = 5.0
@export var distance = 11.0 # find the favoured number from editor
@export var height = 8.0 # find the favoured number from editor

func _physics_process(delta: float) -> void:
	if not target: return
	
	var target_pos = target.global_transform.origin
	var camera_pos = global_transform.origin
	
	# calculate the desired position behine and above target
	var desired_pos = target_pos - target.global_transform.basis.z * distance
	desired_pos.y = target_pos.y + height
	
	# smoothly move toward the desired pos
	camera_pos = camera_pos.lerp(desired_pos, follow_speed * delta)
	global_transform.origin = camera_pos
	
	look_at(target_pos)
