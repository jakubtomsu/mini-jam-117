extends Node2D

export var sin_speed: float = 4

var time_alive: float

func _process(delta):
	time_alive += delta * sin_speed
	$AnimatedSprite.position.y = sin(time_alive) * 2


func _on_Area2D_body_entered(body):
	if body == get_parent().player:
		print("[CoinDrop] player entered")
		queue_free()
		body.coins += 1
