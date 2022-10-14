extends RigidBody2D

export var max_ammo: int = 5
export var ammo: int = max_ammo
const SHOT_FORCE: float = 550.0
const GUN_DIST: float = 30.0
onready var gun = $Gun


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Vector2.ZERO
	if Input.is_action_pressed("player_left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("player_right"):
		dir += Vector2.RIGHT
	if Input.is_action_pressed("player_up"):
		dir += Vector2.UP
	if Input.is_action_pressed("player_down"):
		dir += Vector2.DOWN

	var ndir = dir.normalized()

	if dir.length() > 0.05 && Input.is_action_just_released("player_shoot"):
		shoot(ndir)

	if Input.is_key_pressed(KEY_R):
		reload()

	gun.position = dir * GUN_DIST
	gun.rotation = ndir.angle()


func shoot(dir):
	if ammo > 0:
		linear_velocity = -dir * SHOT_FORCE
		ammo -= 1


func reload():
	ammo = max_ammo
	
func kill():
	print("[Player] kill")
	get_parent().restart()
	pass
