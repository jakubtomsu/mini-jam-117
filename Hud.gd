extends CanvasLayer


func _on_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://campaign/MainMenu.tscn")


func _on_Next_pressed():
	get_tree().paused = false
	if get_parent().next_scene == "":
		get_tree().change_scene("res://campaign/MainMenu.tscn")
	else:
		get_tree().change_scene(get_parent().next_scene)


func _on_Again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
