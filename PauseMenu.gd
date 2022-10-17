extends Popup


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), $VBoxContainer/HSlider.value)


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
	get_tree().change_scene("res://campaign/MainMenu.tscn")


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
