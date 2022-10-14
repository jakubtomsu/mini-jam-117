extends Node2D

onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[Level] player:", player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("level_quick_restart"):
		restart()


func restart():
	get_tree().reload_current_scene()

