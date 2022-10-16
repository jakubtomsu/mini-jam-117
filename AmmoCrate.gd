extends Node2D

onready var player_area = $PlayerArea
const COST = 2

func _process(delta):
	var can_buy = false
	for body in player_area.get_overlapping_bodies():
		var player = get_parent().player
		if body == player:
			if player.ammo < player.MAX_AMMO:
				can_buy = true
				if Input.is_action_just_pressed("player_interact"):
					if player.pay(COST):
						player.ammo = player.MAX_AMMO
	$Control/Label.modulate.a = 1 if can_buy else 0
