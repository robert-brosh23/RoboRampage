class_name Player extends CharacterBody3D

@export var jump_height := 1.0
@export var fall_multiplier := 2.0
@export var sensitivity := 0.005
@export var max_hitpoints := 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var speed = 5.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var experience: int = 0
var experience_needed: int = 25
var hitpoints: int = max_hitpoints:
	set(value):
		if value < hitpoints:
			damage_animation_player.stop(false)
			damage_animation_player.play("TakeDamage")
		if value > max_hitpoints:
			value = max_hitpoints
		hitpoints = value
		print(hitpoints)
		if hitpoints <= 0:
			game_over_menu.game_over()
			
@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var weapon_handler: Node3D = $SubViewportContainer/SubViewport/WeaponCamera/WeaponHandler
@onready var ammo_handler: AmmoHandler = %AmmoHandler
@onready var level_up_menu: Control = $LevelUpMenu


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		handle_camera_rotation()
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier
		
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * sensitivity
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE && event.is_action_pressed("fire"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		weapon_handler.get_current_weapon().can_shoot = false
		await get_tree().create_timer(.05).timeout
		weapon_handler.get_current_weapon().can_shoot = true
		

func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clamp(
		camera_pivot.rotation_degrees.x, -90.0, 90.0
	)
	mouse_motion = Vector2.ZERO
	

func gain_experience(exp_gain: int) -> void:
	experience += exp_gain
	printt(exp_gain, " exp")
	if experience >= experience_needed:
		level_up()
	

func level_up() -> void:
	experience = experience % experience_needed
	experience_needed = experience_needed + 50
	printt("level up!\nexp: ", experience, "/", experience_needed)
	level_up_menu.level_up()
	
