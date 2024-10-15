@tool
extends AnimatableBody3D
class_name CrumblePlatform

const r1 := 7.0
const r2 := 10.0
const total_segments := 36
const platform_thickness := 0.2

const segment_angle := ((2 * PI) / 36)
const half_segment_angle := segment_angle / 2
const r1_to_origin_distance := r1 * (cos(half_segment_angle))
const radial_length := r2 - r1 
const tangent_width := r1 * (sin(segment_angle))

const crumbnle_time = 2

var _is_crumbling := false
var _crumble_counter := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(_create_wing(1))
	add_child(_create_wing(-1))
	add_box_child(self)
	position.x = r1
	
func _create_wing(polarity):
	var anchor = Node3D.new()
	anchor.translate(Vector3(0, 0, (tangent_width / 2) * polarity))
	anchor.rotate(Vector3(0, 1, 0), -1 * half_segment_angle * polarity)
	add_box_child(anchor)
	anchor.get_child(0).translate(Vector3(0, 0, polarity * tangent_width / -2))
	return anchor
	
	
func add_box_child(node: Node):
	# TODO: probably better to use a single box_shape?
	var box_shape := create_box_shape()
	var collision_shape := create_collision_shape(box_shape)
	## Crumble zone spefic
	## TODO: revisit after adding moving platforms for best implementation
	var collision_shape_for_crumble_zone := create_collision_shape(box_shape)
	var crumble_zone := Area3D.new()
	crumble_zone.add_child(collision_shape_for_crumble_zone)
	crumble_zone.body_entered.connect(_body_entered_crumble_zone)
	##
	var box_mesh = MeshInstance3D.new()
	box_mesh.mesh = box_shape.get_debug_mesh()
	collision_shape.add_child(box_mesh)
	collision_shape.add_child(crumble_zone)
	crumble_zone.position.y = 0.1
	node.add_child(collision_shape)
	collision_shape.translate(Vector3(radial_length / 2, 0, 0))

func _body_entered_crumble_zone(body):
	## TODO: add check for player here by extracting player check function
	## perhaps a cast_if_player which returns null if not
	self._is_crumbling = true

func create_box_shape() -> BoxShape3D:
	var box_shape = BoxShape3D.new()
	box_shape.set_size(Vector3(radial_length, platform_thickness, tangent_width)) 
	return box_shape
	
func create_collision_shape(box_shape: BoxShape3D) -> CollisionShape3D:
	var collision_shape = CollisionShape3D.new()
	collision_shape.set_shape(box_shape)
	return collision_shape
	
func _process(delta: float) -> void:
	if self._is_crumbling:#
		print(_crumble_counter)
		if self._crumble_counter > crumbnle_time:
			queue_free()
		else:
			self._crumble_counter += delta
