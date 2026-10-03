extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var damage_particle: GPUParticles3D = $damage_particle

const SPEED = 5.0

var damage := 1
var health := 3

func _physics_process(delta: float) -> void:
	var current_position = global_transform.origin
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)

func update_target_position(target_position):
	nav_agent.target_position = target_position

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
	
func take_damage(amount: int):
	health -= amount
	damage_particle.restart()
	damage_particle.emitting = true
	if health <= 0:
		die()

func die():
	damage_particle.restart()
	damage_particle.emitting = true
	await get_tree().create_timer(.4).timeout
	queue_free()

func _on_hit_detector_body_entered(body: Node3D) -> void:
	# deal damage to player
	if body.has_method("take_damage") and body.is_in_group("players"):
		body.take_damage(damage)
