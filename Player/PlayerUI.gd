extends MarginContainer

@onready var weapon_swap: Node3D = $"../CameraPivot/SmoothCamera/WeaponSwap"
@onready var ammo_label: Label = $HBoxContainer/AmmoLabel
@onready var clip_label: Label = $HBoxContainer/ClipLabel

var ammo
var ammo_in_clip


func _process(delta: float) -> void:
	var current_weapon = weapon_swap.weapons[weapon_swap.curr_weapon_index]
	ammo_label.text = str(current_weapon.total_ammo)
	clip_label.text = str(current_weapon.bullets_in_clip)
