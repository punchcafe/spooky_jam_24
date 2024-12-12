@tool
extends Node3D
# I hate this, but not sure of an easier way to pass properties down

@export var initial_rotation_deg : float
@export var initial_y : float
@export var angle_change : float
@export var half_frequency : float
@export var vertical_change : float
@export var show_end_position := false

func _ready() -> void:
	_pass_values()
	$MovingPlatform.configure_transforms()

func _process(delta: float) -> void:
	_pass_values()

func _pass_values() -> void:
	$MovingPlatform.initial_rotation_deg = self.initial_rotation_deg
	$MovingPlatform.initial_y = self.initial_y
	$MovingPlatform.angle_change = self.angle_change
	$MovingPlatform.half_frequency = self.half_frequency
	$MovingPlatform.vertical_change = self.vertical_change
	$MovingPlatform.show_end_position = self.show_end_position
