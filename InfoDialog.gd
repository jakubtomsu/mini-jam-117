extends CanvasLayer

export var infos = ["info A", "info B"]

var info_index: int = 0

func _ready():
	$Popup.show()
	$Popup/Panel/Text.text = infos[0]
	get_tree().paused = true


func _on_Next_pressed():
	info_index += 1
	if info_index >= infos.size():
		$Popup.hide()
		get_tree().paused = false
		info_index = 0
		return
	$Popup/Panel/Text.text = infos[info_index]
