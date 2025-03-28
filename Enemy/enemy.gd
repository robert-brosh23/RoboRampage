extends CharacterBody3D
class_name Enemy

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const EXP_GIVEN_ON_KILL = 25

@export var max_hitpoints := 100
@export var attack_range := 1.5
@export var attack_damage := 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visor: MeshInstance3D = $Visor

var player: CharacterBody3D
var provoked := false
var aggro_range := 500.0
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			player.gain_experience(EXP_GIVEN_ON_KILL)
			queue_free()
		provoked = true


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	visor.mesh.material.albedo_color = Color(1,0,0)


func _process(delta: float) -> void:
	if provoked:
		navigation_agent_3d.target_position = player.global_position
		if global_position.distance_to(player.global_position) <= attack_range:
			animation_player.play("Attack")


func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var distance := global_position.distance_to(player.global_position)
	if distance <= aggro_range:
		provoked = true
		
	# Handle jump.
	var direction := global_position.direction_to(next_position)
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)
	

func attack() -> void:
	print("enemy attack!")
	player.hitpoints -= attack_damage
	
	
	
