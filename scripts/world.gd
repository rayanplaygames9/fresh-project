extends Node

@onready var player: CharacterBody3D = $player
@onready var timer_zombie_spawn: Timer = $timer_zombie_spawn
@onready var zombie_spawner: Marker3D = $zombie_spawner

const ZOMBIE = preload("uid://hx5luk0hknnf")

func _ready() -> void:
	timer_zombie_spawn.timeout.connect(spawn_zombie)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_position", player.global_transform.origin)

func spawn_zombie():
	var zombie_instance = ZOMBIE.instantiate()
	zombie_instance.position = Vector3(zombie_spawner.position.x, 1, zombie_spawner.position.z)
	add_child(zombie_instance)
