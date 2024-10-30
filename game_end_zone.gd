extends Node3D

var _player : Player
var _awaiting_input := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _awaiting_input and Input.is_anything_pressed():
		_restart_game()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_instance_of(body, Player):
		var player := body as Player
		self._player = player
		var player_camera := player.get_node("./Camera3D") as Camera3D
		var finishing_camera := get_node("MeshInstance3D/Camera3D")
		finishing_camera.set_global_transform(player_camera.global_transform)
		finishing_camera.current = true
		var tween = get_tree().create_tween()
		print(finishing_camera.rotation)
		tween.set_parallel(true)
		tween.tween_property(finishing_camera, "position", Vector3(0, -2, 0), 0.5)
		tween.tween_property(finishing_camera, "rotation", Vector3(PI/2, PI, 0), 0.5)
		tween.tween_callback(_only_show_clock)
		tween.chain()
		tween.tween_property(finishing_camera, "position", Vector3(0, -15, 0), 10)
		tween.chain()
		tween.tween_callback(_enable_restart_game)

func _only_show_clock():
	var finishing_camera := get_node("MeshInstance3D/Camera3D") as Camera3D
	self._player.queue_free()
	finishing_camera.set_cull_mask_value(1, false)

func _enable_restart_game():
	self._awaiting_input = true

func _restart_game():
	get_tree().reload_current_scene()
	
