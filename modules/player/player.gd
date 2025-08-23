class_name Player extends CharacterBody3D


var anim: AnimationPlayer

@export var mouse_sensitivity = 0.01
@export var camera_vertical_limit = deg_to_rad(45)
var camera_rotation = Vector2.ZERO

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const MAX_HP = 500.0

var hp = MAX_HP
var is_dead = false

signal health_changed(new_hp: float, max_hp: float)
signal died(is_dead: bool)

func _ready() -> void:
	anim = $Mage/AnimationPlayer
	
	# Use the player camera
	$SpringArm3D/Camera3D.current = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Horizontal rotation (player turns left/right):
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Vertical rotation (camera looks up/down):
		camera_rotation.y = clamp(
			camera_rotation.y - event.relative.y * mouse_sensitivity,
			- camera_vertical_limit,
			camera_vertical_limit
		)
		$SpringArm3D.rotation.x = camera_rotation.y

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# move_and_slide()

func take_hit(damage: float):
	if is_dead: return
	
	hp -= damage
	is_dead = hp <= 0
	
	if (is_dead):
		$StateMachine.force_transit_to_next_state("Death")
		died.emit(true)
		
	print("PLAYER HP: " + str(hp))
	
	health_changed.emit(hp, MAX_HP)
	
	
	
