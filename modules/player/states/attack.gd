extends PlayerState

@export var projectile_scene: PackedScene

const ATTACK_ANIM = "1H_Melee_Attack_Chop"
const ATTACK_CD = 1.0

var enemies: Array[CharacterBody3D] = []
var attack_timer = 0.0

func enter(previous_state_path: String, data := {}) -> void:
	if enemies.is_empty():
		finished.emit(IDLE, {})
		return

	player.anim.play(ATTACK_ANIM)

func _physics_process(delta):
	if attack_timer > 0:
		attack_timer -= delta

func physics_update(delta: float) -> void:
	check_dead_enemies()

	if enemies.is_empty():
		finished.emit(IDLE, {})

func check_dead_enemies() -> void:
	var i = enemies.size() - 1;
	while i >= 0:
		if is_instance_valid(enemies[i]) and enemies[i].is_dead:
			enemies.remove_at(i)
		i -= 1
	
	sort_enemies()

func sort_enemies() -> void:
	enemies.sort_custom(func(a, b):
		if not is_instance_valid(a) or not is_instance_valid(b):
			return false
			
		return (a.global_position.distance_squared_to(global_position)
			< b.global_position.distance_squared_to(global_position))
		)

func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not anim_name == ATTACK_ANIM:
		return
	
	if not enemies.is_empty():
		for enemy in enemies:
			if not is_instance_valid(enemy): continue
			var projectile = projectile_scene.instantiate()
			var spawn_distance = 2.0
			projectile.target = enemy

			player.get_parent().add_child(projectile)
			var spawn_pos = global_position + (global_transform.basis.z * spawn_distance)
			projectile.global_position = spawn_pos

		attack_timer = ATTACK_CD

	finished.emit(IDLE, {})
