extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var level = get_parent()

func _on_Spike_body_entered(body):
	print("[Spike] body_entered:", body)
	if body == level.player:
		level.player.kill()
