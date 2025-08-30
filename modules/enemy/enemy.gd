extends CharacterBody3D

@onready var enemyAttackSfx = $enemyAttack
@onready var enemyDieSfx = $enemyDie

const SPEED = 5.0
const ATTACK_ANIM = "1H_Melee_Attack_Chop"
const ATTACK_CD = 1.0
const MAX_HP = 100.0
const ATTACK_POWER = 25

var anim: AnimationPlayer
var player: CharacterBody3D
var has_reached_player = false
var attack_timer = 0.0
var hp = 100.0
var is_dead = false
var is_cheering = false

signal health_changed(new_hp: float, max_hp: float)

func _ready() -> void:
	anim = $Barbarian/AnimationPlayer
	anim.play("Idle")
	player = get_tree().get_first_node_in_group('player')
	
	player.died.connect(_on_player_dead)


func _physics_process(delta: float) -> void:
	if is_dead: return
	if is_cheering: return
	
	look_at(player.global_position, Vector3.UP, true)
	
	var is_attacking = anim.current_animation == ATTACK_ANIM
	if (attack_timer > 0 && !is_attacking):
		attack_timer -= delta

	if not has_reached_player:
		move_to_player()
	elif attack_timer <= 0:
		hit_player()


func move_to_player():
	if (anim.current_animation != "Running_B"):
		anim.play("Running_B")

	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	move_and_slide()


func hit_player():
	anim.play(ATTACK_ANIM)

func take_hit(damage: float):
	if is_dead: return
	
	hp -= damage
	is_dead = hp <= 0
	health_changed.emit(hp, MAX_HP)
	
	if (is_dead):
		anim.play("Death_A")
		enemyDieSfx.play()

func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		has_reached_player = true

func _on_attack_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		has_reached_player = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ATTACK_ANIM:
		anim.play("Idle")
		attack_timer = ATTACK_CD
		player.take_hit(ATTACK_POWER)
		enemyAttackSfx.play()
		
	if anim_name == "Death_A":
		$CollisionShape3D.disabled = true
		await get_tree().create_timer(2.0).timeout
		queue_free()

func _on_player_dead(is_dead: bool):
	anim.play("Cheer")
	is_cheering = true
