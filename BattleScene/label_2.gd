extends Label

func _ready():
	var visible = false
	hide()

func _on_button_2_pressed() -> void:
	if visible == false:
		show()
	else:
		hide()
	
	
