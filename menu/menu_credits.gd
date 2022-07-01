extends Control

signal scene_requested(scene)


func _ready():
	$Forground/CenterH/CenterV/CreditsContainer/BackMainMenu.connect("pressed", self, "_on_back_to_main_menu")
	# apparently it does not load directly in scene


func _on_back_to_main_menu():
	emit_signal("scene_requested", "menu")


func _on_link_button_press(url):
	OS.shell_open(url)
