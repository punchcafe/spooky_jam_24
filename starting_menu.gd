extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://root_level.tscn") # Replace with function body.


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn") # Replace with function body.
