extends KinematicBody2D

onready var view_relative = $ViewRelative
onready var wall_check = $ViewRelative/WallCheck
onready var jump_check = $ViewRelative/JumpCheck

export var health: float = 4
export var damage: float = 1
export var speed: float = 15
export var health_drop_chance: float = 0.33
export var is_facing_right: bool = true


const GRAVITY = 200
const ACCELERATION = 50
const JUMP_SPEED = 90
const FRICTION: float = 4.0

var velocity: Vector2


func _process(delta: float):
	if wall_check.is_colliding():
		if !jump_check.is_colliding() && wall_check.get_collider().get_collision_layer() != 2:
			if is_on_floor():
				jump()
		else:
			is_facing_right = !is_facing_right
	
	var dir = 1.0 if is_facing_right else -1.0
	view_relative.scale.x = abs(view_relative.scale.x) * dir
	velocity.x = lerp(velocity.x, speed * dir, delta * ACCELERATION)
	velocity += Vector2.DOWN * GRAVITY * delta
	velocity /= 1.0 + (delta * FRICTION)
	
	if health < 0:
		kill()


func jump():
	velocity += Vector2.UP * JUMP_SPEED


func take_damage(damage: float):
	print("[Enemy] take_damage: ", damage)
	health -= damage


func kill():
	queue_free()


func _physics_process(delta: float):
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	if body == get_parent().player:
		body.take_damage(1)
		body.velocity = (Vector2(-1, -1) if (body.position.x < position.x) else Vector2(1, -1)) * 200
