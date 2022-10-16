extends Popup


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()


func _on_Button_pressed():
	unpause()


func pause():
	get_tree().paused = !get_tree().paused
	show()


func unpause():
	get_tree().paused = false
	hide()


func _on_MainMenu_pressed():
	unpause()
	get_tree().change_scene("res://MainMenu.tscn")
