extends Node2D

export var max_health: float

var health: float = max_health

onready var player_area = $PlayerArea

func _process(delta):
	if Input.is_action_just_pressed("player_interact"):
		for body in player_area.get_overlapping_bodies():
			var player = get_parent().player
			if body == player:
				player.coins
				pass

func repair():
	health = max_health
