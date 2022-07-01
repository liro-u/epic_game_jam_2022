extends Spatial

var can_be_interacted = false


func _ready():
	$Dialogue/Sprite3D.visible = false
	#can_be_interacted = false
	$DialogueCollisonArea.connect("area_entered", self, "_on_area_entered")
	$DialogueCollisonArea.connect("area_exited", self,  "_on_area_exited")


func _on_area_entered(_element):
	can_be_interacted = false
	#$Dialogue/Sprite3D.visible = true


func _on_area_exited(_element):
	can_be_interacted = false
	$Dialogue/Sprite3D.visible = false


func _unhandled_input(event):
	if Input.is_action_pressed("action_interact") && can_be_interacted:
		$Dialogue/Sprite3D.visible = true
