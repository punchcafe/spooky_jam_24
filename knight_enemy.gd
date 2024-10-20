@tool
extends CharacterBody3D
class_name KnightEnemy

const SPEED = 5.0
const JUMP_VELOCITY = 9.0
const RADIUS = 9.5
const RADIUS_SQUARED = RADIUS ** 2

var theta := 0.0
var _direction := -1

@export var starting_rotation_degrees := 0.0
@export var starting_height := 1.0

func _ready():
	self.transform = _initial_transform()

func current_delta():
	return AngularMotionUtils.rotation_from_vec3(get_position())
	
func die():
	get_tree().reload_current_scene()

func theta_change(delta: float) -> float:
	if fall_area().has_overlapping_bodies():
		return _direction * 0.001
	else:
		_direction *= -1
		return 0
	

func fall_area() -> Area3D:
	if _direction == -1:
		return $LHSFallArea as Area3D
	else:
		return $RHSFallArea as Area3D
	

func _physics_process(delta: float) -> void:
	var difference =  AngularMotionUtils.angular_displacement_as_vec3(current_delta(), theta_change(delta), RADIUS)
	var new_velocity = difference / delta # Do this so that it moves the entire way in the delta
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 5
	move_and_slide()
	# This attempts to ensure that stray physics doesn't knock
	# the character off the circumference.
	#move_and_collide(_restorative_distance())

func _restorative_distance() -> Vector3:
	var ideal_position = Vector3(RADIUS, position.y, 0).rotated(Vector3(0, 1, 0), current_delta() * -1)
	var difference = position - ideal_position
	if difference.length() < 0.1:
		return Vector3()
	else:
		return difference * -1
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_in_editor_updates()
		return
	rotation = Vector3(0, -1 * current_delta(), 0)
	
func _initial_transform():
	return AngularMotionUtils.initial_transformation(
		deg_to_rad(starting_rotation_degrees), 
		starting_height
		)
	

func _in_editor_updates():
	self.transform = _initial_transform()
