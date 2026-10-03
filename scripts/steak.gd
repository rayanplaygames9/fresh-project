extends Node3D

@export var item: InvItem

var player = null

func _on_pickup_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		player = body
		player.collect(item)
		queue_free()
