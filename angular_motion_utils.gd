class_name AngularMotionUtils

const RADIUS = 9.5
const RADIUS_SQUARED = RADIUS ** 2

static func rotation_from_vec3(vec3: Vector3) -> float:
	var birdseye_vector := Vector2(vec3.x, vec3.z)
	return birdseye_vector.angle()
	
static func unsigned_rotation_from_vec3(vec3: Vector3) -> float:
	var rotation = rotation_from_vec3(vec3)
	if rotation < 0:
		# The negative angle added to a half rotation gives the positive amount
		return (PI + rotation) + PI
	else:
		return rotation
	
static func vec3_from_rotation(rotation: float, radius: float) -> Vector3:
	var birdseye_vector := Vector2(radius, 0).rotated(rotation)
	return Vector3(birdseye_vector.x, 0, birdseye_vector.y)
	
static func angular_displacement_as_vec3(original_rotation, displacement_rotation, radius):
	var new_position = vec3_from_rotation(original_rotation + displacement_rotation, radius)
	return new_position - vec3_from_rotation(original_rotation, radius)
