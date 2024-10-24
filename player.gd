extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 9.0
const RADIUS = 9.5
const RADIUS_SQUARED = RADIUS ** 2

var theta := 0.0
var double_jumped = false

func current_delta():
	return AngularMotionUtils.rotation_from_vec3(get_position())

# Current junk function because instance of isn't seeming to pick up Player over CharacterBody3D
# Pretty sure worked out the issue, TODO to simplify this and apply it to crumble too
func player_character():
	pass
	
func die():
	get_tree().reload_current_scene()

func theta_change(delta: float):
	if Input.is_action_pressed("ui_right"):
		return -0.5 * delta
	elif Input.is_action_pressed("ui_left"):
		return 0.5 * delta
	else:
		return 0.0
	

func _physics_process(delta: float) -> void:
	var difference =  AngularMotionUtils.angular_displacement_as_vec3(current_delta(), theta_change(delta), RADIUS)
	var new_velocity = difference / delta # Do this so that it moves the entire way in the delta
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 5
	else:
		double_jumped = false
		

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			_jump()
		elif not double_jumped:
			_double_jump()

	move_and_slide()
	# This attempts to ensure that stray physics doesn't knock
	# the player off the circumference.
	move_and_collide(_restorative_distance())

func _restorative_distance() -> Vector3:
	var ideal_position = Vector3(RADIUS, position.y, 0).rotated(Vector3(0, 1, 0), current_delta() * -1)
	var difference = position - ideal_position
	if difference.length() < 0.1:
		return Vector3()
	else:
		return difference * -1

func _jump():
	velocity.y = JUMP_VELOCITY
	
func _double_jump():
	double_jumped = true
	_jump()
	
func _process(delta: float) -> void:
	#pass
	rotation = Vector3(0, -1 * current_delta(), 0)
