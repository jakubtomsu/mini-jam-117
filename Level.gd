extends Node2D

export var num_waves: int = 1
export var spawners: Array

onready var player = $Player
onready var wave_info = $CanvasLayer/WaveInfo
onready var wave_notify = $CanvasLayer/WaveNotify
onready var wave_notify_tween = $CanvasLayer/WaveNotify/Tween

var wave_index: int = 0
var is_using_platforms_a = false
var money: int = 0

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


func start_wave():
	wave_notify_tween.interpolate_property(wave_notify, "modulate:a", 1, 0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	wave_notify_tween.start()
	for s in spawners:
		s.start_wave(wave_index)
	wave_index += 1


func finish_success():
	pass

func finish_fail():
	# TODO
	get_tree().reload_current_scene()
