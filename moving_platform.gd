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

@export var angle_change : float
@export var speed : float
@export var vertical_change : float

var _interpolation_weight_accumulator := 0.
var _interpolation_weight_change_sign = 1.0
var _from_transform : Transform3D
var _to_transform : Transform3D

## TODO: add player restoring force
## TODO: calculate consitent radial velocity
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_from_transform = transform
	_to_transform = transform.rotated(Vector3(0, 1, 0), self.angle_change).translated(Vector3(0., self.vertical_change, 0.))
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
		return
	var completion_ratio = self._interpolation_weight_accumulator
	self.transform = _from_transform.rotated(Vector3(0, 1, 0), self.angle_change * self._interpolation_weight_accumulator).translated(Vector3(0., self.vertical_change * self._interpolation_weight_accumulator, 0.))
	var new_weight = self._interpolation_weight_accumulator + ((self._interpolation_weight_change_sign * delta))
	if(new_weight <= 0 or new_weight >= 1):
		self._interpolation_weight_change_sign *= -1.0
	else:
		print("update val")
		print("new_weight")
		print(new_weight)
		self._interpolation_weight_accumulator = new_weight
