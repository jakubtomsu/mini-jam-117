extends Node2D

export var max_health: int = 5
export var heart_texture: Texture

var health: int = max_health

const REPAIR_COST = 2

onready var player_area = $PlayerArea
onready var repair_label = $Control/Label

func _process(delta):
	var is_player_near = false
	for body in player_area.get_overlapping_bodies():
		var player = get_parent().player
		if body == player:
			is_player_near = true
			if Input.is_action_just_pressed("player_interact"):
				if player.pay(REPAIR_COST):
					repair()
	update()

	repair_label.modulate.a = 1 if is_player_near && health < max_health else 0

	if health <= 0:
		kill()

func repair():
	health = max_health

func take_damage(damage):
	health -= damage


func kill():
	get_parent().finish_fail()


func _draw():
	for i in range(0, health):
		draw_texture(heart_texture, \
		Vector2((float(i) - float(health) * 0.5) * (heart_texture.get_width() + 1), -15))
