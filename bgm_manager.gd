extends Node

const _HEIGHT_VOLUME_INDEX := [15, 30]
const _SILENT_VOLUME := -60.0
const _PLAYING_VOLUME := 0.0

var _last_height_index := 0
var _finished_intro := false
var _player : Player

func _ready() -> void:
	self._player = get_node("../player") as Player
	_set_new_stream(0)

func _process(delta: float) -> void:
	var next_height_index = height_index()
	if next_height_index > _last_height_index:
		# This also adds the effect of not going back
		# to calmer music
		_set_new_stream(next_height_index)
	
func _set_new_stream(index):
	_last_height_index = index
	var stream_player = ($AudioStreamPlayer as AudioStreamPlayer)
	var streams = stream_player.stream as AudioStreamSynchronized
	for stream_index in range(0, streams.get_stream_count()):
		if stream_index == index:
			streams.set_sync_stream_volume(stream_index, _PLAYING_VOLUME)
		else:
			streams.set_sync_stream_volume(stream_index, _SILENT_VOLUME)

func height_index():
	var height = _player.global_position.y
	for i in range(_HEIGHT_VOLUME_INDEX.size()):
		if height < _HEIGHT_VOLUME_INDEX[i]:
			return i
	return _HEIGHT_VOLUME_INDEX.size()

func _on_intro_player_finished() -> void:
	$AudioStreamPlayer.play()
