@abstract
extends Node
## Abstract base class for animation using maths
class_name Dynamics

var dynamic_k1: float
var dynamic_k2: float
var dynamic_k3: float

## Cycles per second, F
## How quickly the target value is reached.
## 1 == 1 hz. Values below 1 is slower, values above 1 is multiples faster.
@export var frequency: float = 1.0:
	set = _set_frequency
## Damping 'shape', Z
## Determines how quickly the value settles at target. 
## 0.0 is infinitely bouncing.
@export var damping_coefficient: float = 0.5:
	set = _set_damping_coefficient

## The initial response of the system, R
## Negative attack overshoots backwards before moving towards target value
## Suggested range: -2.0 - 2.0
@export var attack: float = 0.0:
	set = _set_attack

func _ready() -> void:
	setup_dynamics()

## Shared method for updating dynamics values. 
func setup_dynamics() -> void:
	dynamic_k1 = damping_coefficient / (TAU / 2 * frequency)
	dynamic_k2 = 1 / ((TAU * frequency) * (TAU * frequency))
	dynamic_k3 = attack * damping_coefficient / (TAU * frequency)


@warning_ignore("untyped_declaration")
@abstract func update(_delta: float, _target_value, _velocity)
@warning_ignore("untyped_declaration")
@abstract func initialize(original_value) -> void

func _set_frequency(_frequency: float) -> void:
	frequency = _frequency
	setup_dynamics()


func _set_damping_coefficient(_damping_coefficient: float) -> void:
	damping_coefficient = _damping_coefficient
	setup_dynamics()

func _set_attack(_attack: float) -> void:
	attack = _attack
	setup_dynamics()
	
