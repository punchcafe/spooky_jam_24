class_name AngularMotionUtils

const RADIUS = 9.5
const RADIUS_SQUARED = RADIUS ** 2

static func rotation_from_vec3(vec3: Vector3) -> float:
	var birdseye_vector := Vector2(vec3.x, vec3.z)
	return birdseye_vector.angle()
	
static func vec3_from_rotation(rotation: float) -> Vector3:
	var birdseye_vector := Vector2(RADIUS, 0).rotated(rotation)
	return Vector3(birdseye_vector.x, 0, birdseye_vector.y)
	
static func angular_displacement_as_vec3(original_rotation, displacement_rotation):
	var new_position = vec3_from_rotation(original_rotation + displacement_rotation)#
	return new_position - vec3_from_rotation(original_rotation)
