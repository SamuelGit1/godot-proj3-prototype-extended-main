extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if _is_move_input():
		finished.emit(MOVE, {})
	else:
		player.anim.play("Idle")

func physics_update(delta: float) -> void:
	if _is_move_input():
		finished.emit(MOVE, {})
	elif Input.is_action_just_pressed("attack"):
		finished.emit(ATTACK, {})

func _is_move_input():
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	return input_dir != Vector2.ZERO
