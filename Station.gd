extends Node2D

onready var level = get_parent()
onready var area = $Area2D
onready var buy_label = $Control/Label

func _process(delta):
	var is_player_near = false
	for body in area.get_overlapping_bodies():
		if body == level.player:
			# player near station
			is_player_near = true

	if is_player_near:
		buy_label.rect_position.y += 1
	buy_label.modulate.a = lerp(buy_label.modulate.a, 1 if is_player_near else 0, delta * 10)

