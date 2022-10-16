extends Area2D

func _process(delta):
	for b in get_overlapping_bodies():
		if b == get_parent().player:
			get_parent().finish_success()
