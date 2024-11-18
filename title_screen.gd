extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://root_level.tscn")
