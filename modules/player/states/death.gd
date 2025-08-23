extends PlayerState

var anim: AnimationPlayer

func enter(_previous_state_path: String, _data := {}) -> void:
	player.anim.play("Death_A")
