extends Area3D

@export var ammo_type: AmmoHandler.ammo_type
@export var amount: int

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	idle_rotate(delta)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.ammo_handler.ammo_storage[ammo_type] += amount
	queue_free()

func idle_rotate(delta: float):
	mesh_instance_3d.rotate_x(.3 * delta)
	mesh_instance_3d.rotate_y(.1 * delta)
	mesh_instance_3d.rotate_z(.5 * delta)
