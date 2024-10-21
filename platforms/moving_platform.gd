@tool
extends Platform
class_name MovingPlatform

@export var initial_rotation_deg := 0.0
@export var initial_y := 1.0
# TODO: rename total_angle_change
@export var angle_change := 10.0
@export var speed_degrees_per_second := 4.0
@export var vertical_change := 0.0
@export var show_end_position := false

var _current_angle_change := 0.
var _interpolation_weight_change_sign = 1.0
var _from_transform : Transform3D
var _to_transform : Transform3D

func _ready() -> void:
	super()
	_from_transform = _starting_transform()
	_to_transform = _destination_transform(_from_transform)
	
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_in_editor_updates()
		return
	var new_angle_change = _current_angle_change + (self._interpolation_weight_change_sign * delta * self.speed_degrees_per_second)
	var completion_ratio = new_angle_change / self.angle_change
	if(completion_ratio <= 0 or completion_ratio >= 1):
		self._interpolation_weight_change_sign *= -1.0
	else:
		self.transform = _from_transform.rotated(Vector3(0, 1, 0), deg_to_rad(self.angle_change) * completion_ratio).translated(Vector3(0., self.vertical_change * completion_ratio, 0.))
		self._current_angle_change = new_angle_change
		
func _destination_transform(initial_transform: Transform3D) -> Transform3D:
	return _from_transform.rotated(Vector3(0, 1, 0), deg_to_rad(self.angle_change)).translated(Vector3(0., self.vertical_change, 0.))

func _starting_transform() -> Transform3D:
	# TODO: extract into utils
	var inital_transform = Transform3D()
	return inital_transform.translated(Vector3(7.0, 0, 0)).rotated(Vector3(0,1,0), deg_to_rad(self.initial_rotation_deg)).translated(Vector3(0, self.initial_y, 0))

func _in_editor_updates() -> void:
	if self.show_end_position:
		self.transform = _destination_transform(_starting_transform())
	else:
		self.transform = _starting_transform()
	
