extends Node
class_name AmmoHandler

@export var starting_small_ammo: int
@export var starting_mid_ammo: int

enum ammo_type {
	BULLET,
	SMALL_BULLET
}

var ammo_storage := {
	ammo_type.BULLET: 0,
	ammo_type.SMALL_BULLET: 0,
}

func _ready() -> void:
	add_to_group("ammo_handler")
	ammo_storage[ammo_type.BULLET] = starting_mid_ammo
	ammo_storage[ammo_type.SMALL_BULLET] = starting_small_ammo

func has_ammo(type: ammo_type) -> bool:
	return ammo_storage[type] > 0

func get_ammo_for_reload(type: ammo_type, clip_size: int) -> int:
	var amount = min(clip_size, ammo_storage[type])
	ammo_storage[type] -= amount
	return amount
