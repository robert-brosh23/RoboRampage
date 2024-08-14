extends Area3D

@export var ammo_type: AmmoHandler.ammo_type
@export var amount: int

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.ammo_handler.ammo_storage[ammo_type] += amount
	queue_free()
