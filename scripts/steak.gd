extends Node3D



func _on_pickup_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		queue_free()
		body.add_child(self)
