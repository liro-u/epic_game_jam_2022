extends ColorRect

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		visible = !visible
		get_tree().set_input_as_handled()

