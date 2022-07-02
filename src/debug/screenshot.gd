extends Node

const file_screenshot_path = "res://assets/screenshot/"

func _physics_process(delta):
	input_process(delta)
	
func input_process(_delta):
	if Input.is_action_just_pressed("screenshot"):
		make_screenshot()
	
func make_screenshot():
	#get screenshot
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	
	#save screenshot
	var dir = Directory.new()
	if dir.open(file_screenshot_path) == OK:
		#name screenshot
		var n = 0
		var name_screenshot = "screen_" + str(n) + ".png"
		#search for a free name
		while dir.file_exists(name_screenshot):
			n += 1
			name_screenshot = "screen_" + str(n) + ".png"
		#save screenshot at path indicated
		img.save_png(file_screenshot_path + name_screenshot)
		print("INFO : screenshot " + name_screenshot + " has been saved")
	else:
		print("ERROR : file_screenshot_path is incorrect")
