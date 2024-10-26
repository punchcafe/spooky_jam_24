extends Control

var _original_position : Vector2

func _ready() -> void:
	self._original_position = $ColorRect.position
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "position", _original_position + Vector2(2000, 0), 0.4)
	tween.tween_callback(self._set_left)
	add_to_group("game_over_listeners")

func _process(delta: float) -> void:
	pass

func handle_game_over():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "position", _original_position + Vector2(500, 0), 0.4)
	tween.tween_callback(self._restart_game)
	
func _set_left():
	$ColorRect.position = _original_position + Vector2(-2000, 0)
	
func _restart_game():
	get_tree().reload_current_scene()
	
