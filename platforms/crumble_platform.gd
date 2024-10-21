@tool
extends Platform
class_name CrumblePlatform

@export var crumble_time := 2.0

var _is_crumbling := false
var _crumble_counter := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	self._inject_crumble_zone(self)
	self._inject_crumble_zone(self._lhs_collision_anchor.get_child(0))
	self._inject_crumble_zone(self._rhs_collision_anchor.get_child(0))
	
func _inject_crumble_zone(node: Node3D):
	var box_shape := create_box_shape()
	var collision_shape_for_crumble_zone := create_collision_shape(box_shape)
	var crumble_zone := Area3D.new()
	crumble_zone.add_child(collision_shape_for_crumble_zone)
	crumble_zone.body_entered.connect(_body_entered_crumble_zone)
	crumble_zone.position.y = 0.1
	node.add_child(crumble_zone)

func _body_entered_crumble_zone(body: Node):
	if PlayerReactions.is_player(body):
		self._is_crumbling = true

	
func _process(delta: float) -> void:
	if self._is_crumbling:
		if self._crumble_counter > crumble_time:
			queue_free()
		else:
			self._crumble_counter += delta
