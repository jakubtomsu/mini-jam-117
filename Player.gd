extends KinematicBody2D

onready var level = get_parent()
var speed = Vector2(500, 1000)
var gravity = 2500
var friction = 0.2
var air_friction = 0.04
var acceleration = 0.1
var velocity = Vector2.ZERO
var ammo = MAX_AMMO
const MAX_AMMO = 3


func _physics_process(delta: float) -> void:
	if is_on_floor():
		ammo = MAX_AMMO
	
	var dir = get_direction()
	var is_jump_interupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	velocity = calculate_velocity(velocity, dir, is_jump_interupted, speed, delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func get_direction():
	var result: Vector2
	result.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
		
	if ammo > 0 && Input.is_action_just_pressed("player_shoot"):
		result += Vector2.UP
		ammo -= 1
		level.switch_platforms()

	return result
	

func calculate_velocity(curVelocity, dir, is_jump_interupted, speed, delta):
	var out = Vector2.ZERO

	if dir.x != 0:
		out.x = lerp(curVelocity.x, dir.x * speed.x, acceleration)
	else:
		out.x = lerp(curVelocity.x, 0, friction if is_on_floor() else air_friction)

	if(dir.y == -1.0): # Jumping
		out.y = dir.y * speed.y
	else: # Falling
		out.y = curVelocity.y + (gravity * delta)

	if(is_jump_interupted): # jump key release
		out.y = 0.0 + (gravity * delta)

	return out

func kill():
	level.restart()
