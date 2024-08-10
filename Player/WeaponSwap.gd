extends Node3D

@export var weapon_lock_out_threshold = .1

@onready var weapon_lockout_timer: Timer = $WeaponLockoutTimer
@onready var weapons_node: Node3D = $Weapons

var weapons
var curr_weapon_index
var num_weapons


func _ready() -> void:
	weapon_lockout_timer.wait_time = weapon_lock_out_threshold
	
	weapons = weapons_node.get_children()
	num_weapons = weapons.size()
	for weapon in weapons:
		weapon.equipped = false
	curr_weapon_index = 0
	swap_to_weapon(weapons[curr_weapon_index], weapons[curr_weapon_index])
	

func _process(delta: float) -> void:
	process_input(delta)


func process_input(delta: float) -> void:
	if !weapon_lockout_timer.is_stopped():
		return
		
	var previous_weapon = weapons[curr_weapon_index]
	if Input.is_action_just_pressed("switch_weapon_to_next"):
		curr_weapon_index = min(curr_weapon_index + 1, num_weapons - 1)
		swap_to_weapon(weapons[curr_weapon_index], previous_weapon)
	if Input.is_action_just_pressed("switch_weapon_to_previous"):
		curr_weapon_index = max(curr_weapon_index - 1, 0)
		swap_to_weapon(weapons[curr_weapon_index], previous_weapon)
	if Input.is_action_just_pressed("switch_weapon_to_1"):
		curr_weapon_index = 0
		swap_to_weapon(weapons[curr_weapon_index], previous_weapon)
	if Input.is_action_just_pressed("switch_weapon_to_2"):
		curr_weapon_index = min(1, num_weapons - 1)
		swap_to_weapon(weapons[curr_weapon_index], previous_weapon)
	if Input.is_action_just_pressed("switch_weapon_to_3"):
		curr_weapon_index = min(2, num_weapons - 1)
		swap_to_weapon(weapons[curr_weapon_index], previous_weapon)


func swap_to_weapon(weapon_in: Node3D, previous_weapon: Node3D) -> void:
	previous_weapon.equipped = false
	weapon_in.equipped = true
	weapon_lockout_timer.start()
