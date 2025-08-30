extends PlayerState

@onready var walkingSfx = $walking

const ANIMATION = "Running_B"
const SPEED = 5.0

func enter(_previous_state_path: String, data := {}) -> void:
	var _input_dir = data.get("input_dir", Vector2.ZERO)
	player.anim.play(ANIMATION)
	walkingSfx.play()

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		finished.emit(ATTACK, {})
		
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	elif input_dir == Vector2.ZERO:
		finished.emit(IDLE, {})
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	
	player.move_and_slide()

func exit():
	walkingSfx.stop()
