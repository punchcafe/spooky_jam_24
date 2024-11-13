extends Control

func _ready() -> void:
	get_node("Control/StartButton").grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()


func _on_start_button_pressed() -> void:
	$Control.queue_free()
	var tween := get_tree().create_tween()
	var tween_time := 0.3
	tween.tween_property($BlackOverlay, "color:a", 1, tween_time)
	var camera := get_node("../OutsideScene/Camera3D")
	var destination_transform := (get_node("../GameStartCameraPosition") as Node3D).global_transform
	tween.parallel().tween_property(camera, 
		"global_transform:origin", 
		destination_transform.origin, 
		tween_time
	)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://root_level.tscn") )


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn") # Replace with function body.
