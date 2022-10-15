extends Node2D

onready var player = $Player
var is_using_platforms_a = false
var money: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[Level] player:", player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("level_quick_restart"):
		get_tree().reload_current_scene()
		
	if player.health < 0:
		finish_fail()


func finish_success():
	pass

func finish_fail():
	# TODO
	get_tree().reload_current_scene()
