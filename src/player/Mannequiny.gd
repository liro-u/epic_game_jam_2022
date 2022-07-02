extends Spatial
class_name Mannequiny

enum States { IDLE, WALK, RUN, AIR, LAND }

var move_direction := Vector3.ZERO setget set_move_direction
var is_moving := false


func _ready() -> void:
	pass


func set_move_direction(direction: Vector3) -> void:
	move_direction = direction
	pass


func transition_to(state_id: int) -> void:
	match state_id:
		_:
			pass
