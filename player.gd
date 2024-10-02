extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 9.0
const RADIUS = 9.5
const RADIUS_SQUARED = RADIUS ** 2

var theta := 0.0
var double_jumped = false

func current_delta():
	return delta_from_vec3(get_position())

func delta_from_vec3(vec3: Vector3) -> float:
	var birdseye_vector := Vector2(vec3.x, vec3.z)
	return birdseye_vector.angle()
	
func vec3_from_delta(delta: float) -> Vector3:
	var birdseye_vector := Vector2.from_angle(delta)
	var side_ratios = birdseye_vector.x / birdseye_vector.y
	var y = sqrt(RADIUS_SQUARED / (1 + pow(side_ratios, 2)))
	var x = sqrt(RADIUS_SQUARED - pow(y, 2))
	return Vector3(x, get_position().y, y)

func theta_change(delta: float):
	if Input.is_action_pressed("ui_right"):
		return -3 * delta
	elif Input.is_action_pressed("ui_left"):
		return 3 * delta
	else:
		return 0.0
	

func _physics_process(delta: float) -> void:
	var new_position = vec3_from_delta(current_delta() + theta_change(delta))
	if is_equal_approx(theta_change(delta), 0.0):
		velocity.x = 0.0
		velocity.z = 0.0
	else:
		var difference = get_position().direction_to(new_position)
		var new_velocity = difference * 5 # Do this so that it moves the entire way in the delta
		velocity.x = new_velocity.x
		velocity.z = new_velocity.z

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 5
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
	
func _process(delta: float) -> void:
	#pass
	rotation = Vector3(0, -1 * current_delta(), 0)
