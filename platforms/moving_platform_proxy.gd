@tool
extends Node3D
# I hate this, but not sure of an easier way to pass properties down

@export var initial_rotation_deg := 0.0
@export var initial_y := 1.0
@export var angle_change := 10.0
@export var speed := 10.0
@export var vertical_change := 0.0
@export var show_end_position := false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$MovingPlatform.initial_rotation_deg = self.initial_rotation_deg
	$MovingPlatform.initial_y = self.initial_y
	$MovingPlatform.angle_change = self.angle_change
	$MovingPlatform.speed = self.speed
	$MovingPlatform.vertical_change = self.vertical_change
	$MovingPlatform.show_end_position = self.show_end_position
