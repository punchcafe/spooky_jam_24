extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation_player := $blockbench_export.get_node("AnimationPlayer") as AnimationPlayer
	animation_player.play("fiyah")
	var anim = animation_player.get_animation("fiyah")
	anim.loop_mode =(Animation.LOOP_LINEAR)

func _requeue(_signal):
	var animation_player := $blockbench_export.get_node("AnimationPlayer") as AnimationPlayer
	animation_player.queue("fiyah")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
