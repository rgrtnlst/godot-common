## Ripped straight from Tessel8r by painstakingly recreating the steps taken throughout the video:
## https://www.youtube.com/watch?v=KPoeNZZ6H4
extends Dynamics
class_name Vector3Dynamics

var previous_value: Vector3
var new_value: Vector3
var velocity: Vector3


func initialize(original_value: Vector3) -> void:
	new_value = original_value
	previous_value = original_value


func update(_delta: float, _target_value: Vector3, _velocity: Vector3 = Vector3.ZERO) -> Vector3:
	if _velocity.is_equal_approx(Vector3.ZERO):
		_velocity = (_target_value - previous_value) / _delta
		previous_value = _target_value
		
	new_value += _delta * velocity
	velocity += _delta * (_target_value + dynamic_k3 * _velocity - new_value - dynamic_k1 * velocity) / dynamic_k2
	
	return new_value
