extends Node

@onready var player: CharacterBody3D = $player
@onready var timer_zombie_spawn: Timer = $timer_zombie_spawn
@onready var jumpscare_texture: TextureRect = $CanvasLayer/jumpscare_texture
@onready var timer_cow_spawn: Timer = $timer_cow_spawn
@onready var music_box_coll_area: Area3D = $MusicBox/coll_area
@onready var phonkbaby: AudioStreamPlayer3D = $MusicBox/PHONKBABY

const ZOMBIE = preload("uid://hx5luk0hknnf")
const COW = preload("uid://ctqdd4hjxgal0")

func _ready() -> void:
	timer_zombie_spawn.timeout.connect(spawn_zombie)
	timer_cow_spawn.timeout.connect(spawn_cow)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_position", player.global_transform.origin)

func spawn_zombie():
	var rand_x = randf_range(-10.0, 10.0)
	var rand_z = randf_range(-10.0, 10.0)
	var zombie_instance = ZOMBIE.instantiate()
	zombie_instance.position = Vector3(rand_x, 1, rand_z)
	add_child(zombie_instance)
	zombie_instance.get_node_or_null("jumpscare_sound").play()
	jumpscare_texture.show()
	await get_tree().create_timer(.7).timeout
	jumpscare_texture.hide()
	
func spawn_cow():
	var rand_x = randf_range(-10.0, 10.0)
	var rand_z = randf_range(-10.0, 10.0)
	var cow_instance = COW.instantiate()
	cow_instance.position = Vector3(rand_x, 1.0, rand_z)
	add_child(cow_instance)

func _on_coll_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		phonkbaby.play()
