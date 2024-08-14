extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		for weapon in body.weapon_swap.weapons:
			weapon.total_ammo += weapon.clip_size * 4
	queue_free()
