extends Node3D

@export var fire_rate := 14.0
@export var recoil := .05
@export var damage := 10
@export var automatic := true
@export var weapon_mesh : Node3D
@export var muzzle_flash : GPUParticles3D
@export var sparks : PackedScene
@export var animation_player: AnimationPlayer

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast: RayCast3D = $RayCast3D

var equipped: bool = false:
	set(equipped_in):
		if equipped_in == true:
			visible = true
			if animation_player == null:
				printt("animation player for weapon ", get_name(), " not attached")
				equip_weapon_default()
			else:
				animation_player.play("equip")
			var timer:SceneTreeTimer = get_tree().create_timer(.3)
			timer.timeout.connect(set.bind("can_shoot", true))
		else:
			can_shoot = false
			visible = false
		equipped = equipped_in

var can_shoot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_shooting(delta)


func process_shooting(delta: float):
	if !can_shoot:
		return
	if automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	else: 
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
			
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)


func shoot() -> void:
	muzzle_flash.restart()
	cooldown_timer.start(1.0 / fire_rate)
	var collider = ray_cast.get_collider()
	printt("weapon fired!", collider)
	weapon_mesh.position.z += recoil
	if collider is Enemy:
		collider.hitpoints -= damage
	if collider == null:
		return
	var spark = sparks.instantiate()
	add_child(spark)
	spark.global_position = ray_cast.get_collision_point()
	

func equip_weapon_default() -> void:
	var tween_rotation = create_tween()
	var tween_position = create_tween()
	
	weapon_mesh.rotation_degrees.x = 58.0
	tween_rotation.tween_property(weapon_mesh, "rotation_degrees", Vector3(0, 0, 0), .3)
	
	var equip_position = weapon_mesh.position
	weapon_mesh.position = Vector3(equip_position.x, equip_position.y + .7, equip_position.z + .7)
	tween_position.tween_property(weapon_mesh, "position", equip_position, .3)

