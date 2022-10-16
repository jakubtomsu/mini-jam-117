extends Node2D

export var num_waves: int = 1

onready var player = $Player
onready var wave_info = $CanvasLayer/WaveInfo
onready var wave_notify = $CanvasLayer/WaveNotify

var wave_index: int = 0
var is_using_platforms_a = false
var wave_time: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("[Level] player:", player)
	start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("level_quick_restart"):
		get_tree().reload_current_scene()

	if player.health <= 0:
		finish_fail()

	wave_time += delta
	if wave_time > 1:
		wave_notify.visible = false
	
	var is_unfinished = false
	var spawners = get_tree().get_nodes_in_group("spawner")
	for s in spawners:
		if !s.is_wave_spawned():
			is_unfinished = true
	
	if !is_unfinished:
		if get_tree().get_nodes_in_group("enemy").size() <= 0:
			start_wave()


# Next wave
func start_wave():
	get_tree().call_group("spawner", "start_wave", wave_index)
	wave_index += 1

	wave_notify.text = "Wave " + str(wave_index)
	wave_info.text = "Wave " + str(wave_index) + "/" + str(num_waves)


func finish_success():
	pass

func finish_fail():
	# TODO
	get_tree().reload_current_scene()
