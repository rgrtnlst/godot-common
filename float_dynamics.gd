## Ripped straight from Tessel8r by painstakingly recreating the steps taken throughout the video:
## https://www.youtube.com/watch?v=KPoeNZZ6H4

extends Dynamics
class_name FloatDynamics

var previous_value: float
var new_value: float
var velocity: float
#A new comment thank you very much

func initialize(_original_value: float) -> void:
	pass

func update(_delta: float, _target_value: float, _velocity: float = 0.0) -> float:
	if is_zero_approx(_velocity):
		_velocity = (_target_value - previous_value) / _delta
		previous_value = _target_value
		
	new_value += _delta * velocity
	velocity += _delta * (_target_value + dynamic_k3 * _velocity - new_value - dynamic_k1 * velocity) / dynamic_k2
	
	return new_value
