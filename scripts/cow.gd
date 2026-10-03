extends CharacterBody3D

@onready var timer_change_dir: Timer = $timer_change_dir
@onready var damage_particle: GPUParticles3D = $damage_particle

var speed := 3.8
var gravity := -30.0
var health := 3

var move_dir := Vector3.ZERO

func _ready() -> void:
	pick_random_dir()
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity
		
	else:
		velocity.y = 0.0
		
	velocity.x = move_dir.x * speed
	velocity.z = move_dir.z * speed
	
	move_and_slide()
	
	# if on wall pick random direction instanlty
	if is_on_wall():
		pick_random_dir()
		timer_change_dir.start()
		
func pick_random_dir():
	var x = randf_range(-1.0, 1.0)
	var z = randf_range(-1.0, 1.0)
	
	var target_vector = Vector3(x, 0.0, z)
	
	# check if the vector has length to avoid errors, then normalize it
	if target_vector.length() > 0:
		move_dir = target_vector.normalized()
		
	else:
		move_dir = Vector3.ZERO
		
func take_damage(amount: int):
	health -= amount
	damage_particle.restart()
	damage_particle.emitting = true
	if health <= 0:
		die()
		
func die():
	queue_free()

func _on_timer_change_dir_timeout() -> void:
	pick_random_dir()
