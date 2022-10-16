extends Node2D

onready var player_area = $PlayerArea
const COST = 2

func _process(delta):
	var is_player_near = false
	for body in player_area.get_overlapping_bodies():
		var player = get_parent().player
		if body == player:
			is_player_near = true
			if Input.is_action_just_pressed("player_interact"):
				if player.pay(COST):
					player.ammo = player.MAX_AMMO
	$Control/Label.modulate.a = 1 if is_player_near else 0
