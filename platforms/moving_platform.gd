@tool
extends AnimatableBody3D
class_name MovingPlatform

const r1 := 7.0
const r2 := 10.0
const total_segments := 36
const platform_thickness := 0.2

const segment_angle := ((2 * PI) / 36)
const half_segment_angle := segment_angle / 2
const r1_to_origin_distance := r1 * (cos(half_segment_angle))
const radial_length := r2 - r1 
const tangent_width := r1 * (sin(segment_angle))

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

## TODO: add player restoring force
## TODO: calculate consitent radial velocity
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_from_transform = _starting_transform()
	_to_transform = _destination_transform(_from_transform)
	add_child(_create_wing(1))
	add_child(_create_wing(-1))
	add_box_child(self)
	
func _create_wing(polarity):
	var anchor = Node3D.new()
	anchor.translate(Vector3(0, 0, (tangent_width / 2) * polarity))
	anchor.rotate(Vector3(0, 1, 0), -1 * half_segment_angle * polarity)
	add_box_child(anchor)
	anchor.get_child(0).translate(Vector3(0, 0, polarity * tangent_width / -2))
	return anchor
	
	
func add_box_child(node: Node):
	var box_shape := create_box_shape()
	var collision_shape := create_collision_shape(box_shape)
	var box_mesh = MeshInstance3D.new()
	box_mesh.mesh = box_shape.get_debug_mesh()
	collision_shape.add_child(box_mesh)
	node.add_child(collision_shape)
	collision_shape.translate(Vector3(radial_length / 2, 0, 0))

func create_box_shape() -> BoxShape3D:
	var box_shape = BoxShape3D.new()
	box_shape.set_size(Vector3(radial_length, platform_thickness, tangent_width)) 
	return box_shape
	
func create_collision_shape(box_shape: BoxShape3D) -> CollisionShape3D:
	var collision_shape = CollisionShape3D.new()
	collision_shape.set_shape(box_shape)
	return collision_shape
	
	
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
	
