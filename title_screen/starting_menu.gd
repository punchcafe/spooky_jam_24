extends Control

var _current_focus_button : Button

func _ready() -> void:
	randomise_credits_order()
	get_viewport().connect("gui_focus_changed", self._on_focus_changed)
	var start_button = get_node("TitleScreen/HBoxContainer/StartButton")
	start_button.grab_focus()
	$Cursor.global_position = start_button.global_position

func _on_focus_changed(control):
	if is_instance_of(control, Button):
		self._current_focus_button = control
	else:
		self._current_focus_button = null
	$FocusChangedSound.play()

func _process(delta: float) -> void:
	if _current_focus_button: 
		$Cursor.global_position = _current_focus_button.global_position \
		+ Vector2(_current_focus_button.size.x / -2.0, 0) \
		+ Vector2(-10.0, 0.0)
		
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()


func _on_start_button_pressed() -> void:
	$TitleScreen.visible = false
	$Cursor.visible = false
	var tween := get_tree().create_tween()
	var tween_time = $GameStartSound.get_stream().get_length()
	$GameStartSound.play()
	var camera := get_node("../OutsideScene/Camera3D")
	var destination_transform := (get_node("../GameStartCameraPosition") as Node3D).global_transform
	tween.tween_property($BlackOverlay, "color:a", 1.0, tween_time).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(camera, 
		"global_transform:origin", 
		destination_transform.origin, 
		tween_time
	)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://level/root_level.tscn") )


func _on_credits_pressed() -> void:
	_toggle_visibilities()

func _on_credits_back_button_pressed() -> void:
	_toggle_visibilities()

func _toggle_visibilities() -> void:
	$Credits.visible = not $Credits.visible
	$TitleScreen.visible = not $TitleScreen.visible
	if $TitleScreen.visible:
		get_node("TitleScreen/HBoxContainer/StartButton").grab_focus()
	else:
		randomise_credits_order()
		get_node("Credits/VBoxContainer/Button").grab_focus()
		
func randomise_credits_order() -> void:
	if randi_range(0,9) >= 5:
		var portrait_holder = $Credits.get_node("PortraitContainer")
		portrait_holder.move_child(portrait_holder.get_child(0), 1)
