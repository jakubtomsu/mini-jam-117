extends Node2D

onready var player = $Player
onready var platforms_a = $PlatformsA
onready var platforms_b = $PlatformsB
var is_using_platforms_a = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[Level] player:", player)
	switch_platforms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("level_quick_restart"):
		restart()


func restart():
	get_tree().reload_current_scene()
	
func switch_platforms():
	platforms_a.set_collision_layer_bit(0, is_using_platforms_a)
	platforms_a.set_collision_mask_bit(0, is_using_platforms_a)
	# platforms_a.visible = is_using_platforms_a
	platforms_a.modulate.a = 1.0 if is_using_platforms_a else 0.5
	
	platforms_b.set_collision_layer_bit(0, !is_using_platforms_a)
	platforms_b.set_collision_mask_bit(0, !is_using_platforms_a)
	# platforms_b.visible = !is_using_platforms_a
	platforms_b.modulate.a = 1.0 if !is_using_platforms_a else 0.5
	
	is_using_platforms_a = !is_using_platforms_a
