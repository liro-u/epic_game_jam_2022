extends Control

signal scene_requested(scene)



func _ready():
	#$GUI/Body/MainSection/Menu/LobbyCreationButton.connect("pressed", self, "create_lobby")
	$GUI/Body/MainSection/Menu/OptionButton.connect("pressed", self, "_on_menu_option_pressed")
	$GUI/Body/MainSection/Menu/CreditsButton.connect("pressed", self, "_on_menu_credits_pressed")
	$GUI/Body/MainSection/Menu/Quit.connect("pressed", self, "_quit_game")


func _quit_game():
	get_tree().quit()


func _on_menu_option_pressed():
	emit_signal("scene_requested", "option_menu")


func _on_menu_credits_pressed():
	emit_signal("scene_requested", "credits_menu")
