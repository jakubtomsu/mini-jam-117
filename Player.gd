extends KinematicBody2D

onready var level = get_parent()
onready var raycast = $GunRayCast
onready var shoot_timer = $ShootTimer
onready var turnable = $Turnable
onready var anim = $Turnable/AnimatedSprite
onready var hud_health = $HUD/HBoxContainer/Values/Health
onready var hud_ammo = $HUD/HBoxContainer/Values/Ammo
onready var hud_coins = $HUD/HBoxContainer/Values/Coins
onready var turret = preload("res://AreaDamageTurret.tscn")
onready var shoot_hit_effect = preload("res://PlayerShootHitEffect.tscn")

const SHOOT_JUMP_SPEED = 200
const MAX_AMMO = 12

var speed = Vector2(80, 160)
var gravity = 500
var friction = 40.0
var air_friction = 6.0
var air_friction_y = 2.5
var acceleration = 20
var velocity = Vector2.ZERO
var ammo = MAX_AMMO
var is_facing_right: bool = true

var max_health: int = 4
var health: int = max_health
var coins: int


func _process(delta):
	if Input.is_key_pressed(KEY_R):
		ammo = MAX_AMMO
	
	var move_dir: = Input.get_action_strength("player_right") - \
		Input.get_action_strength("player_left")
	
	# state animations
	if anim.animation != "shoot" && anim.animation != "take_damage":
		if is_on_floor(): 
			if abs(move_dir) > 0.01:
				if anim.animation != "run":
					anim.play("run")
			else:
				anim.play("default")
		else:
			if velocity.y > 0:
				anim.play("fall")
	else:
		if anim.frame + 1 >= anim.get_sprite_frames().get_frame_count(anim.animation):
			anim.play("default")
	
	
	if move_dir != 0:
		velocity.x = lerp(velocity.x, move_dir * speed.x, acceleration * delta)
	else:
		velocity.x /= 1.0 + (delta * (friction if is_on_floor() else air_friction))
	velocity.y /= 1.0 + (delta * air_friction_y)
	
	# Jumping
	if Input.is_action_just_pressed("player_jump") && is_on_floor():
		velocity = Vector2.UP * speed.y
		anim.play("jump")
	
	var aim_dir = get_aim_dir()
		
	if Input.is_action_just_pressed("player_shoot"):
		shoot(aim_dir)
		anim.play("shoot")
	if Input.is_action_just_pressed("player_jump") && !is_on_floor():
		shoot(Vector2.DOWN)
		anim.play("jump_shot")

	if Input.is_action_just_pressed("player_left"):
		is_facing_right = false
	if Input.is_action_just_pressed("player_right"):
		is_facing_right = true

	# HACK: -1
	turnable.scale.x = abs(turnable.scale.x) * (1 if is_facing_right else -1) * -1

	if Input.is_action_just_pressed("player_build"):
		var t = turret.instance()
		t.position = position
		get_parent().add_child(t)
		pass

	# UI
	hud_health.text = str(health)
	hud_ammo.text = str(ammo)
	hud_coins.text = str(coins)


func get_aim_dir() -> Vector2:
	var face_dir = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
	return face_dir


func take_damage(damage: int):
	if anim.animation != "take_damage":
		health -= damage
		print("[Player] take_damage: ", damage, " health: ", health)
		anim.play("take_damage")


func shoot(dir: Vector2):
	if ammo > 0:
		if shoot_timer.time_left > 0:
			return
			
		shoot_timer.start()
		
		var force = (SHOOT_JUMP_SPEED * 0.2) if is_on_floor() else SHOOT_JUMP_SPEED
		velocity = -dir.normalized() * force
		ammo -= 1

		raycast.enabled = true
		raycast.set_cast_to(dir * 1000)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			print(raycast.get_collision_point())
			var effect = shoot_hit_effect.instance()
			# effect.position = raycast.get_collision_point()
			get_parent().add_child(effect)
			effect.init_from_to(position, raycast.get_collision_point())
			var c = raycast.get_collider()
			if c.has_method("on_shot"):
				c.on_shot()
			if c.get_parent().has_method("on_shot"):
				c.get_parent().on_shot()
		raycast.enabled = false


func pay(required_coins) -> bool:
	if coins >= required_coins:
		coins -= required_coins
		return true
	else:
		return false


func _physics_process(delta: float):
	velocity += Vector2.DOWN * gravity * delta * (0.1 if is_on_floor() else 1)
	velocity = move_and_slide(velocity, Vector2.UP)
