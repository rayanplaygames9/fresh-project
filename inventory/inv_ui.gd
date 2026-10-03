extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var reticle: Panel = $"../../Reticle"

var is_open := false

func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inv"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	reticle.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func close():
	visible = false
	is_open = false
	reticle.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
