extends PlayerState

var anim: AnimationPlayer
@onready var playerLoseSfx = $playerLoseSfx

func enter(_previous_state_path: String, _data := {}) -> void:
	player.anim.play("Death_A")
	playerLoseSfx.play()
