extends Control

signal ressource_loaded(ressource_name, ressource)
signal finished()
# warning-ignore:unused_signal
signal scene_requested(scene) # not used used finished instead

enum STATE_NETWORK_ELEMENT {
	WAIT,
	OK,
	ERROR,
}

const GREEN = Color(50.0 / 255.0, 191.0 / 255.0, 87.0 / 255.0)
const RED = Color(191.0 / 255.0, 62.0 / 255.0, 50.0 / 255.0)
const ORANGE = Color(214.0 / 255.0, 150.0 / 255.0, 0.0)


var loaded_factions = 0
var loaded_ship_models = 0
var load_queue = {} setget set_load_queue
var queue_finished = false
var loader = null
var current_load_element = null
var has_emited_finished = false
var _number_of_element_to_load = 0
var _current_loading_component_load = 0


onready var global_progressbar = $Foreground/MarginContainer/VBoxContainer/ressources/ressourceLoading/GlobalProgress
onready var ressource_progressbar = $Foreground/MarginContainer/VBoxContainer/ressources/ressourceLoading/ProgressBar
onready var loading_componenet_label = $Foreground/MarginContainer/VBoxContainer/ressources/ressourceLoading/LoadingComponenet
onready var quit_button = $Foreground/MarginContainer/VBoxContainer/VBoxContainer/QuitButton
onready var label_loading_error = $Foreground/MarginContainer/VBoxContainer/ressources/ressourceLoading/LoadingError
onready var version_label = $Foreground/MarginContainer/VBoxContainer/VersionLabel


func _ready():
	version_label.text = tr("global.loading.version %s") % Config.VERSION.version
	quit_button.visible = false
	Store.connect("notification_added", self, "_on_notification_added")
	# if we wait too much and there is no queue of element to load we want to quit
	quit_button.connect("pressed", self, "_on_press_quit")


func _on_timeout_res():
	queue_finished = queue_finished or load_queue.size() == 0 # if the queue is empty we set that we have finished
	verify_is_finished()


func _on_press_quit():
	get_tree().quit()


func set_state_label(state, node):
	match state:
		STATE_NETWORK_ELEMENT.OK:
			node.add_color_override("font_color", GREEN)
			node.text = tr("global.loading.ok")
		STATE_NETWORK_ELEMENT.WAIT:
			node.add_color_override("font_color", ORANGE)
			node.text = tr("global.loading.waiting")
		STATE_NETWORK_ELEMENT.ERROR:
			node.add_color_override("font_color", RED)
			node.text = tr("global.loading.error")
		

func set_load_queue(load_queue_param):
	_current_loading_component_load = 0
	has_emited_finished = false
	load_queue = load_queue_param
	for i in load_queue.values():
		if i.scene == null:
			_number_of_element_to_load += 1 
	update_progress()
	queue_finished = _number_of_element_to_load == 0
	if queue_finished:
		verify_is_finished()
	else:
		set_process(true)


func verify_is_finished():
	if queue_finished \
			and not has_emited_finished:
		has_emited_finished = true
		emit_signal("finished")


func _process(_delta):
	if loader == null or current_load_element == null:
		current_load_element = null
		var keys = load_queue.keys()
		for i in keys:
			if load_queue[i].scene == null:
				current_load_element = i
				_current_loading_component_load += 1
				update_global_progress()
				break
		if current_load_element != null:
			loader = ResourceLoader.load_interactive(load_queue[current_load_element].path)
		else:
			queue_finished = keys.size() > 0 # we only set as finished if the queue has element, we have a timer for mark as finished if the queue is emtpy
			# however this menu is not meant to be shown if there is no elements to load
			verify_is_finished()
			set_process(false)
			return
	# poll your loader
	var err = loader.poll()
	if err == ERR_FILE_EOF: # Finished loading.
		var resource = loader.get_resource()
		load_queue[current_load_element].scene = resource
		emit_signal("ressource_loaded", current_load_element, resource)
		loader = null
		current_load_element = null
		update_progress()
	elif err == OK:
		pass
	else: # error during loading
		quit_button.visible = true
		label_loading_error.text += (tr("global.loading.ressource.error %s %d") % [tr("global.loading.ressource." + current_load_element) ,err]) + "\n"
		set_process(false)
		loader = null
		current_load_element = null
	update_progress()


func update_progress():
	if loader!= null :
		ressource_progressbar.max_value = loader.get_stage_count()
		ressource_progressbar.value = loader.get_stage()
		ressource_progressbar.get_node("Label").text = tr("global.loading.progressbar_ressource %d %d") % [loader.get_stage(), loader.get_stage_count()]
	else: 
		ressource_progressbar.value = ressource_progressbar.max_value 
		ressource_progressbar.get_node("Label").text = tr("global.loading.progressbar_ressource %d %d") % [ressource_progressbar.max_value, ressource_progressbar.max_value]


func update_global_progress():
	loading_componenet_label.text = tr("global.loading.ressource." + current_load_element) if current_load_element != null else tr("global.loading.none_loading")
	global_progressbar.max_value = _number_of_element_to_load
	global_progressbar.value = _current_loading_component_load
	global_progressbar.get_node("Label").text = tr("global.loading.progressbar_global %d %d") % [_current_loading_component_load, _number_of_element_to_load]
