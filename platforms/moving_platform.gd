@tool
extends Platform
class_name MovingPlatform

@export var initial_rotation_deg := 0.0
@export var initial_y := 1.0
# TODO: rename total_angle_change
@export var angle_change := 10.0
# How many times to complete a length (half full oscillation) in 1s
@export var half_frequency := 0.5
@export var vertical_change := 0.0
# TODO: separate union for vertical ONLY changes and dedicates speed.
# Maybe frequency is a better parameter?
@export var show_end_position := false

var _current_completion_fraction := 0.
var _interpolation_weight_change_sign = 1.0
var _from_transform : Transform3D
var _to_transform : Transform3D

func _ready() -> void:
	_from_transform = _starting_transform()
	print(initial_y)
	print(angle_change)
	print(initial_rotation_deg)
	_to_transform = _destination_transform(_from_transform)
	super()
	
func configure_transforms():
	_from_transform = _starting_transform()
	_to_transform = _destination_transform(_from_transform)

func _fraction_increase(delta):
	# The fraction of total travel which should be done this frame
	return half_frequency * delta * 2

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_in_editor_updates()
		return
	var new_completion_fraction = self._current_completion_fraction + (self._interpolation_weight_change_sign * _fraction_increase(delta))
	if(new_completion_fraction <= 0 or new_completion_fraction >= 1):
		self._interpolation_weight_change_sign *= -1.0
	else:
		self.transform = _from_transform.rotated(Vector3(0, 1, 0), deg_to_rad(self.angle_change) * new_completion_fraction).translated(Vector3(0., self.vertical_change * new_completion_fraction, 0.))
		self._current_completion_fraction = new_completion_fraction
		
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
	
