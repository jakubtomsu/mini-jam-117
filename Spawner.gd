extends Node2D

export var num_enemies_per_wave: int = 4
export var pre_wave_time: float = 2
export var spawn_time: float = 2
export var is_facing_right: bool = true

onready var pre_wave_timer = $PreWaveStartTimer
onready var spawn_timer = $SpawnTimer
onready var enemy = preload("res://Enemy.tscn")

var enemies: Array
var num_spawned_enemies: int

func _ready():
	scale.x *= 1 if is_facing_right else -1

func start_wave(index):
	pre_wave_timer.start(pre_wave_time)
	num_spawned_enemies = 0
	print("[Spawner] start wave: ", index)


func _on_SpawnTimer_timeout():
	print("[Spawner] _on_SpawnTimer_timeout")
	if num_spawned_enemies < num_enemies_per_wave:
		num_spawned_enemies += 1
		spawn_enemy()
		spawn_timer.start(spawn_time)


func spawn_enemy():
	print("[Spawner] spawn enemy")
	var e = enemy.instance()
	e.position = position
	e.is_facing_right = is_facing_right
	get_parent().add_child(e)


func is_wave_spawned() -> bool:
	return num_spawned_enemies >= num_enemies_per_wave


func _on_PreWaveStartTimer_timeout():
	print("[Spawner] _on_PreWaveStartTimer_timeout")
	spawn_timer.start(spawn_time)
