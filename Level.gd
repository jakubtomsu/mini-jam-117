extends Node2D

onready var player = $Player
onready var platforms_a = $PlatformsA
onready var platforms_b = $PlatformsB
var is_using_platforms_a = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[Level] player:", player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("level_quick_restart"):
		restart()


func restart():
	get_tree().reload_current_scene()
