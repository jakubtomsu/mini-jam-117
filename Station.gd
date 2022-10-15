extends Node2D

onready var level = get_parent()
onready var area = $Area2D

func _process(delta):
	for body in area.get_overlapping_bodies():
		if body == level.player:
			# player near station
			pass
