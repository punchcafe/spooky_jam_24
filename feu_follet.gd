@tool
extends OmniLight3D
class_name FeuFollet

@export var phase := 0.0

@export var preview_movement := false
@export var x_delta := 0.0
@export var y_delta := 0.0
@export var z_delta := 0.0
@export var brightness_delta := 0.0

var _original_position : Vector3
var _original_energy : float
var _accumulator := 0.0
var _delta : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_original_position = self.position
	_original_energy = self.light_energy
	_delta = Vector3(self.x_delta, self.y_delta, self.z_delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and not preview_movement:
		return
	self._accumulator += delta
	self._accumulator = fmod(self._accumulator, 2.0 * PI)
	var phase_fraction = sin(self._accumulator + self.phase)
	var new_position = self._original_position + (phase_fraction * self._delta)
	var new_energy = self._original_energy + (self.brightness_delta * phase_fraction)
	self.light_energy = new_energy
	self.position = new_position
