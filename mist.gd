extends Area3D
class_name Mist

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	position += Vector3(0, 0.02, 0)


func _on_body_entered(body: Node3D) -> void:
	if is_instance_of(body, Player):
		(body as Player).die()
