extends Node3D

const MIN_SPAWN_DELAY_IN_SECONDS = 2.0

@export var enemy_scene: PackedScene
@export var player: CharacterBody3D
var spawn_locations = []
var timer


func _ready() -> void:
	for child in get_children():
		if child is Node3D:
			spawn_locations.append(child.position)
			
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_enemy"):
		spawn_enemy()
	
	
func spawn_enemy() -> void:
	if enemy_scene != null:
		var spawn_location = player.position
		while (spawn_location.distance_to(player.position) < 30):
			spawn_location = spawn_locations[randi() % spawn_locations.size()]
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_location
		add_child(enemy)
