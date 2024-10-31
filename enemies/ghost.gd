extends Node3D

var _hunt_started := false
var _player: Player
const MAX_MOVEMENT := 0.4

func current_rotation():
	return AngularMotionUtils.rotation_from_vec3(get_position())

func _ready() -> void:
	$Sprite3D.transparency = 1.0
	$AnimationPlayer.play("default")

func _process(delta: float) -> void:
	if not _hunt_started:
		return
	var new_transparency = max($Sprite3D.transparency - (delta * 0.4), 0.4)
	$Sprite3D.transparency = new_transparency
	var rot_movement = clamp(_rotation_between_ghost_and_player(), -1 * MAX_MOVEMENT, MAX_MOVEMENT)
	_set_animation_direction(rot_movement)
	var new_rotation_position = AngularMotionUtils.vec3_from_rotation(current_rotation() + -1 * (rot_movement * delta), 9.5)
	var new_vertical_position = Vector3(0, position.y + _clamped_vertical_difference() * delta, 0)
	set_position(new_rotation_position + new_vertical_position)

func _set_animation_direction(rot_movement):
	$Sprite3D.flip_h = rot_movement < 0

func _rotation_between_ghost_and_player():
	var ghost_rotation = AngularMotionUtils.unsigned_rotation_from_vec3(get_position())
	var player_rotation = AngularMotionUtils.unsigned_rotation_from_vec3(_player.get_position())
	var difference = ghost_rotation - player_rotation
	if abs(difference) > PI:
		# Why the hell does this work
		difference =  sign(difference * -1)*(PI - abs(fmod(difference, PI)))
	return difference

func _clamped_vertical_difference():
	var difference = _player.position.y - self.position.y
	return clamp(difference, -1 * MAX_MOVEMENT, MAX_MOVEMENT)
	

func _begin_hunt(player: Player):
	self._hunt_started = true
	self._player = player

func _on_awaken_zone_body_entered(body: Node3D) -> void:
	if PlayerReactions.is_player(body):
		_begin_hunt(body as Player)

func _on_body_zone_body_entered(body: Node3D) -> void:
	PlayerReactions.kill_if_player(body)
