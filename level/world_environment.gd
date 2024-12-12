extends WorldEnvironment

@export var target_color := Color(1.0, 1.0, 1.0)
const MAX_HEIGHT := 70.0
var _current_max_height := 0.0
var _original_color : Color
var _difference : Color
var _player : Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._original_color = self.environment.background_color
	self._difference = _original_color - target_color
	self._player = get_node("../player") as Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self._player.global_position.y > _current_max_height:
		self._current_max_height = self._player.global_position.y
		var clamped_height = min(self._player.global_position.y, MAX_HEIGHT)
		var height_fraction = clamped_height / MAX_HEIGHT
		self.environment.background_color = self._original_color + (self._difference * height_fraction)
	
	
