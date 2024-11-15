extends Node3D

var _player : Player
var _awaiting_input := false
var _finishing_camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._finishing_camera = get_node("MeshInstance3D/Camera3D") as Camera3D
	var animation_player := $ClockMesh.get_node("AnimationPlayer") as AnimationPlayer
	var animation_player_2 := $ClockMesh.get_node("ClockMesh2/AnimationPlayer") as AnimationPlayer
	# Update when we have a single asset
	animation_player.play("clockloopreverse")
	animation_player_2.play("clockloopreverse")
	# TODO: fix this code
	animation_player = $OutsideScene.get_node("ClockFaceMesh/AnimationPlayer") as AnimationPlayer
	animation_player.play("clockloopreverse")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _awaiting_input and Input.is_anything_pressed():
		_trigger_game_restart()
		self._awaiting_input = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_instance_of(body, Player):
		var player := body as Player
		self._player = player
		var player_camera := player.get_node("./Camera3D") as Camera3D
		_finishing_camera.set_global_transform(player_camera.global_transform)
		_finishing_camera.current = true
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(_finishing_camera, "position", Vector3(0, -2, 0), 0.5)
		tween.tween_property(_finishing_camera, "rotation", Vector3(PI/2, PI, 0), 0.5)
		tween.tween_callback(_only_show_clock)
		tween.chain()
		tween.tween_property(_finishing_camera, "position", Vector3(0, -15, 0), 2)
		tween.chain()
		tween.tween_callback(_enable_restart_game)

func _only_show_clock():
	self._player.queue_free()
	_finishing_camera.set_cull_mask_value(1, false)

func _enable_restart_game():
	self._awaiting_input = true

func _trigger_game_restart():
	var starting_camera := $OutsideScene.get_node("Camera3D") as Camera3D
	_finishing_camera.reparent($OutsideScene)
	var tween = get_tree().create_tween()
	tween.tween_property(_finishing_camera, "position", starting_camera.position, 0.3)
	tween.parallel().tween_property(_finishing_camera, "fov", starting_camera.fov, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_callback(self._restart_game)
	

func _restart_game():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	
