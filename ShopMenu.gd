extends Popup

onready var player = get_node("/root/Node2D/Player")

func _process(delta):
	if Input.is_action_just_pressed("shop_menu"):
		if visible:
			enable_shop()
		else:
			disable_shop()
		player.set_process(!visible)

func enable_shop():
	hide()
	
func disable_shop():
	show()
