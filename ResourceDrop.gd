extends Node2D

export var add_health: int = 1
export var add_coins: int = 0
export var sin_speed: float = 2

var time_alive: float

func _process(delta):
	time_alive += delta * sin_speed
	$Sprite.position.y = sin(time_alive)


func _on_Area2D_body_entered(body):
	if body == get_parent().player:
		print("[ResourceDrop] player entered")
		queue_free()
