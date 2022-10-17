extends KinematicBody2D

onready var view_relative = $ViewRelative
onready var wall_check = $ViewRelative/WallCheck
onready var jump_check = $ViewRelative/JumpCheck
onready var anim = $ViewRelative/AnimatedSprite

export var health: float = 4
export var damage: int = 1
export var speed: float = 15
export var health_drop_chance: float = 0.33
export var coin_drop_chance: float = 0.33
export var is_facing_right: bool = true


const GRAVITY = 200
const ACCELERATION = 50
const JUMP_SPEED = 80
const FRICTION: float = 3.5

var velocity: Vector2

func _ready():
	randomize()

func _process(delta: float):
	if $AttackExpl.visible:
		velocity = Vector2.ZERO
		return
	
	if wall_check.is_colliding():
		print("[Enemy] colliding")
		if wall_check.get_collider().is_in_group("terminal"):
		#if wall_check.get_collision_mask_bit(3):
			attack(wall_check.get_collider())
		elif !jump_check.is_colliding():
			if is_on_floor():
				jump()
		elif wall_check.get_collision_mask_bit(0):
			is_facing_right = !is_facing_right
	
	var dir = 1.0 if is_facing_right else -1.0
	view_relative.scale.x = abs(view_relative.scale.x) * dir
	velocity.x = lerp(velocity.x, speed * dir, delta * ACCELERATION)
	velocity += Vector2.DOWN * GRAVITY * delta
	velocity /= 1.0 + (delta * FRICTION)
	
	if health < 0:
		kill()


func jump():
	velocity.y = -JUMP_SPEED


func attack(collider):
	print("[Enemy] attack: ", collider)
	var n = collider.get_parent()
	if n.has_method("take_damage"):
		print("[Enemy] attack: damage")
		n.take_damage(damage)
	anim.play("attack")
	var expl = $AttackExpl
	expl.play("default")
	expl.visible = true

func attack_finished():
	queue_free()


func take_damage(damage: float):
	print("[Enemy] take_damage: ", damage)
	health -= damage
	anim.play("damage")


func kill():
	var n: Node
	if randf() < 0.5:
		n = preload("res://CoinDrop.tscn").instance()
	else:
		n = preload("res://HealthDrop.tscn").instance()
	n.position = position
	get_parent().add_child(n)
	queue_free()

func on_shot():
	take_damage(0.5)

func _physics_process(delta: float):
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	if body == get_parent().player:
		body.take_damage(1)


func _on_AttackExpl_animation_finished():
	attack_finished()


func _on_AnimatedSprite_animation_finished():
	anim.play("default")
