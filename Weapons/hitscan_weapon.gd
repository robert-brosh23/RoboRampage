extends Node3D

@export var fire_rate := 14.0
@export var recoil := .05
@export var damage := 10
@export var clip_size := 20
@export var ammo_type : AmmoHandler.ammo_type
@export var automatic := true
@export var reload_time := 1.0

@export var weapon_mesh : Node3D
@export var muzzle_flash : GPUParticles3D
@export var sparks : PackedScene
@export var animation_player: AnimationPlayer
@export var ammo_handler: AmmoHandler

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var reload_timer: Timer = $ReloadTimer

var equipped: bool = false:
	set(equipped_in):
		if equipped_in == true:
			visible = true
			if animation_player == null || !animation_player.has_animation("equip"):
				printt("animation player for weapon ", get_name(), " not configured. Doing default animation")
				play_animation_equip_weapon_default()
			else:
				animation_player.play("equip")
			var timer:SceneTreeTimer = get_tree().create_timer(.3)
			timer.timeout.connect(set.bind("can_shoot", true))
		else:
			reload_timer.stop()
			can_shoot = false
			visible = false
		equipped = equipped_in

var can_shoot = false
var bullets_in_clip

func _ready() -> void:
	bullets_in_clip = clip_size
	reload_timer.wait_time = reload_time


func _process(delta: float) -> void:
	process_shooting(delta)


func process_shooting(delta: float):
	if !can_shoot:
		return
		
	if Input.is_action_just_pressed("reload"):
		if cooldown_timer.is_stopped():
			reload()
	if automatic && bullets_in_clip > 0:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
			
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)


func shoot() -> void:
	if bullets_in_clip <= 0:
		print("out of ammo!")
		weapon_mesh.position.z += .1
		cooldown_timer.start(.3)
		return
		
	muzzle_flash.restart()
	cooldown_timer.start(1.0 / fire_rate)
	var collider = ray_cast.get_collider()
	printt("weapon fired!", collider)
	weapon_mesh.position.z += recoil
	bullets_in_clip -= 1
	
	if collider is Enemy:
		collider.hitpoints -= damage
	if collider == null:
		return
	var spark = sparks.instantiate()
	add_child(spark)
	spark.global_position = ray_cast.get_collision_point()
	

func reload() -> void:
	if bullets_in_clip == clip_size:
		return
	if !ammo_handler.has_ammo(ammo_type):
		print("cannot reload, out of ammo")
		return
	can_shoot = false
	reload_timer.start()
	play_animation_reload_default()
	

func finish_reload() -> void:
	can_shoot = true
	bullets_in_clip += ammo_handler.get_ammo_for_reload(ammo_type, clip_size - bullets_in_clip)


func play_animation_equip_weapon_default() -> void:
	var tween_rotation = create_tween()
	var tween_position = create_tween()
	
	weapon_mesh.rotation_degrees.x = 58.0
	tween_rotation.tween_property(weapon_mesh, "rotation_degrees", Vector3(0, 0, 0), .3)
	
	var equip_position = weapon_mesh.position
	weapon_mesh.position = Vector3(equip_position.x, equip_position.y + .7, equip_position.z + .7)
	tween_position.tween_property(weapon_mesh, "position", equip_position, .3)


func play_animation_reload_default() -> void:
	var tween_rotation = create_tween()
	var tween_position = create_tween()
	
	tween_rotation.tween_property(weapon_mesh, "rotation_degrees", Vector3(60.0, 0, 0), reload_time/3.0)
	tween_rotation.tween_interval(reload_time/3.0)
	tween_rotation.tween_property(weapon_mesh, "rotation_degrees", Vector3(0, 0, 0), reload_time/3.0)

