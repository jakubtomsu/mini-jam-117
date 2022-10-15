extends KinematicBody2D

onready var level = get_parent()
onready var body = $Body
onready var gun = $Gun
onready var raycast = $RayCast2D

onready var shoot_hit_effect = preload("res://PlayerShootHitEffect.tscn")

const SHOOT_JUMP_SPEED = 450
const MAX_AMMO = 12

var speed = Vector2(200, 250)
var gravity = 900
var friction = 0.5
var air_friction = 0.05
var air_friction_y = 0.015
var acceleration = 0.22
var velocity = Vector2.ZERO
var ammo = MAX_AMMO
var is_facing_right: bool = true

var max_health: int = 4
var health: int = max_health


func _physics_process(delta: float):
	velocity = move_and_slide(velocity, Vector2.UP)

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		ammo = MAX_AMMO
	
	var move_dir: = Input.get_action_strength("player_right") - \
		Input.get_action_strength("player_left")
	
	if move_dir != 0:
		velocity.x = lerp(velocity.x, move_dir * speed.x, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction if is_on_floor() else air_friction)
	
	velocity.y = lerp(velocity.y, 0, air_friction_y)
		
	# Jumping
	if Input.is_action_just_pressed("player_jump") && is_on_floor():
		velocity = Vector2.UP * speed.y
	else: # Falling
		velocity += Vector2.DOWN * gravity * delta
	
	var aim_dir = get_aim_dir()
		
	if Input.is_action_just_pressed("player_shoot"):
		shoot(aim_dir)
	
	if Input.is_action_just_pressed("player_jump") && !is_on_floor():
		shoot(Vector2.DOWN)

	gun.position = aim_dir * 30
	gun.rotation = aim_dir.angle()

	if Input.is_action_just_pressed("player_left"):
		is_facing_right = false
	if Input.is_action_just_pressed("player_right"):
		is_facing_right = true
	body.scale.x = abs(body.scale.x) * (1 if is_facing_right else -1)


	if health <= 0:
		kill()


func get_aim_dir() -> Vector2:
	var face_dir = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
	return face_dir


func take_damage(damage: int):
	health -= damage
	print("[Player] take_damage: ", damage, " health: ", health)


func kill():
	level.restart()


func shoot(dir: Vector2):
	print("[Player] shoot dir: ", dir)
	if ammo > 0:
		var force: float = SHOOT_JUMP_SPEED * 0.2 if is_on_floor() else SHOOT_JUMP_SPEED
		velocity = -dir * speed
		ammo -= 1
		
		raycast.enabled = true
		raycast.set_cast_to(dir * 1000)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			print(raycast.get_collision_point())
			var effect = shoot_hit_effect.instance()
			effect.position = raycast.get_collision_point()
			get_parent().add_child(effect)
			var c = raycast.get_collider()
			if c.has_method("on_shot"):
				c.on_shot()
		raycast.enabled = false
		
