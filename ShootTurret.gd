extends Node2D

onready var active_timer = $ActiveTimer
onready var shoot_timer = $ShootTimer

func _on_ShootTimer_timeout():
	if active_timer.time_left > 0:
		print("[ShootTurret] shoot")


func on_shot():
	print("[ShootTurret] activated")
	active_timer.start()
	shoot_timer.start()
