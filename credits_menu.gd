extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus()
	pass # Replace with function 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_game"):
		get_tree().change_scene_to_file("res://title_screen.tscn")
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
