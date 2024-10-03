extends Area3D
class_name Mist

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector3(0, 0.02, 0)


func _on_body_entered(body: Node3D) -> void:
	if is_instance_of(body, Player):
		get_tree().reload_current_scene()
	pass # Replace with function body.
