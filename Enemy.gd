extends KinematicBody2D

onready var view_relative = $ViewRelative
onready var wall_check = $ViewRelative/WallCheck
onready var jump_check = $ViewRelative/JumpCheck

export var health: float = 4
export var damage: float = 1
export var speed: float = 10
export var health_drop_chance: float = 0.33
export var is_facing_right: bool = true


const GRAVITY = 100
const ACCELERATION = 50
const JUMP_SPEED = 600

var velocity: Vector2


func _process(delta: float):
	if wall_check.is_colliding():
		if !jump_check.is_colliding():
			jump(delta)
		else:
			is_facing_right = !is_facing_right
	
	var dir = 1.0 if is_facing_right else -1.0
	view_relative.scale.x = abs(view_relative.scale.x) * dir
	velocity.x = lerp(velocity.x, speed * dir, delta * ACCELERATION)
	velocity += Vector2.DOWN * GRAVITY * delta
	
	if health < 0:
		kill()


func jump(delta):
	velocity += Vector2.UP * JUMP_SPEED * delta


func take_damage(damage: float):
	print("[Enemy] take_damage: ", damage)
	health -= damage


func kill():
	queue_free()


func _physics_process(delta: float):
	velocity = move_and_slide(velocity, Vector2.UP)
