extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var charge_time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
		
	if Input.is_action_pressed("player_charge"):
		charge_time += delta

	if Input.is_action_just_released("player_charge"):
		shoot(dir)
		charge_time = 0

	print(charge_time)

	$Gun.position = dir * 100

func shoot(dir):
	linear_velocity -= dir * 100 * charge_time

