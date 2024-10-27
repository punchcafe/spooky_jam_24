@tool
extends Node3D

@export var broken_pillar := false
@export var regular_pillar := false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_set_children()

func _set_children():
	$BrokenPillar.set_visible(broken_pillar)
	$RegularPillar.set_visible(regular_pillar)
	
	
