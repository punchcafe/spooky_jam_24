extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_jump() -> void:
	$JumpFXPlayer.play()
	
func play_land() -> void:
	$LandFXPlayer.play()
	
func play_die() -> void:
	$DieFXPlayer.play()
