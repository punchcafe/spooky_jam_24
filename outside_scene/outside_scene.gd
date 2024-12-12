extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	($ClockFaceMesh.get_node("AnimationPlayer") as AnimationPlayer).play("clockloopreverse")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
