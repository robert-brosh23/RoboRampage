extends MarginContainer

@onready var weapon_handler: Node3D = $"../SubViewportContainer/SubViewport/WeaponCamera/WeaponHandler"
@onready var ammo_label: Label = $HBoxContainer/AmmoLabel
@onready var clip_label: Label = $HBoxContainer/ClipLabel
@onready var ammo_handler: AmmoHandler = $"../SubViewportContainer/SubViewport/WeaponCamera/AmmoHandler"


func _process(delta: float) -> void:
	var current_weapon = weapon_handler.weapons[weapon_handler.curr_weapon_index]
	clip_label.text = str(current_weapon.bullets_in_clip)
	ammo_label.text = str(ammo_handler.ammo_storage[current_weapon.ammo_type])
