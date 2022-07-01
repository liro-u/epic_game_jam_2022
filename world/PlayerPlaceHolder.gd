extends CSGBox



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _unhandled_input(event):
	if Input.is_action_pressed("action_change_world"):
		var parent_node = self.get_parent()
		parent_node.is_up = !parent_node.is_up
		if parent_node.is_up:
			# this order is wanted as the last step is always to set to visible
			for node in get_tree().get_nodes_in_group("DownWorld"):
				node.visible = false
			for node in get_tree().get_nodes_in_group("UpWorld"):
				node.visible = true 
		else:
			for node in get_tree().get_nodes_in_group("UpWorld"):
				node.visible = false
			for node in get_tree().get_nodes_in_group("DownWorld"):
				node.visible = true 
		 # TODO call a method on each ellement, might be to heavy ?
