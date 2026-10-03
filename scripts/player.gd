extends CharacterBody3D

@onready var head: Node3D = $head
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $CanvasLayer/HUD/health_bar
@onready var sword_hitbox: Area3D = $head/Camera3D/Sword/MeshInstance3D2/sword_hitbox
@onready var slot: Panel = $CanvasLayer/HUD/slot
@onready var slot_2: Panel = $CanvasLayer/HUD/slot2
@onready var slot_3: Panel = $CanvasLayer/HUD/slot3

const SPEED = 7.8
const JUMP_VELOCITY = 10.0

var gravity := -30.0
var mouse_sensitivity := 0.005
var health := 5
var sword_damage := 1
var selected_slot = slot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("left_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if animation_player.current_animation != "throw":
			animation_player.play("throw")
			sword_hitbox.monitoring = true
			
	if Input.is_action_just_pressed("1"):
		selected_slot = slot
	elif Input.is_action_just_pressed("2"):
		selected_slot = slot_2
	elif Input.is_action_just_pressed("3"):
		selected_slot = slot_3
		
	print(selected_slot)

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# die from void
	if velocity.y < -30.0:
		die_and_restart()

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _process(delta: float) -> void:
	if not animation_player.is_playing():
		sword_hitbox.monitoring = false
	
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die_and_restart()
	health_bar.value = health

func die_and_restart():
	health = 5
	position = Vector3.ZERO
	health_bar.value = 5

func _on_sword_hitbox_body_entered(body: Node3D) -> void:
	# deal damage to enemy
	if body.has_method("take_damage") and body.is_in_group("enemies"):
		body.take_damage(sword_damage)
		
	# deal damage to cow too (or all animals)
	if body.has_method("take_damage") and body.is_in_group("animals"):
		body.take_damage(sword_damage)
