extends Node2D

func _ready():
	var a = $AnimatedSprite
	a.play("default")
	$AnimatedSprite2.play("default")

func _on_AnimatedSprite_animation_finished():
	queue_free()

func init_from_to(from: Vector2, to: Vector2):
	position = from
	rotation = (to - from).angle()
	$AnimatedSprite.position = to_local(to)
	var l = $AnimatedSprite2
	l.scale.y = ((from - to).length() / 16.0) - 0.7
	l.position = to_local((from + to) * 0.5)
