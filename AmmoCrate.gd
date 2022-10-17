extends Node2D

onready var player_area = $PlayerArea
const COST = 1

func _process(delta):
	var can_buy = false
	for b in player_area.get_overlapping_bodies():
		if b.is_in_group("player"):
			if b.ammo < b.MAX_AMMO:
				can_buy = true
				if Input.is_action_just_pressed("player_interact"):
					if b.pay(COST):
						b.ammo = b.MAX_AMMO
	$Control/Label.modulate.a = 1 if can_buy else 0
