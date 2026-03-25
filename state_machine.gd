## Class to use for managing states in object that benefits from using states.
## 
## Example use:
## [codeblock]
## var state_machine: StateMachine
## func _ready():
## 	# Use Callable() if no method is needed
## 	state_machine.add_state(state_idle, state_idle_enter, Callable())
## 	state_machine.set_initial_state(state_idle)
## 	
## 
## func _process(delta: float) -> void:
## 	state_machine.update()
## 
## 
## func state_idle_enter() -> void:
## 	# Setup initial state variables
## 	pass
## 
##
## func state_idle() -> void:
## 	# Runs every frame through [method StateMachine.update]
## 	pass
## [/codeblock]
class_name  StateMachine

var state_dictionary: Dictionary[String, State] = {}
var current_state: String

signal state_changed(old_state: String, new_state: String)

## Adds a triplet of functions to the state machine. [param normal_state] required, the rest can be omitted by providing an empty [Callable] as [code]Callable()[/code]
func add_state (normal_state: Callable, enter_state: Callable, leave_state: Callable) -> void:
	state_dictionary[normal_state.get_method()] = State.new(normal_state, enter_state, leave_state)


func set_initial_state(state: Callable) -> void:
	var state_key:StringName  = state.get_method()
	if state_dictionary.has(state_key):
		_set_state(state_key)
	else:
		push_warning("No state with name %s stored in state machine" % state_key)
	

func update() -> void:
	if current_state == "":
		return
	state_dictionary[current_state].normal.call()
	
func change_state(state: Callable) -> void:

	var state_key:StringName = state.get_method()
	if state_dictionary.has(state_key):
		_set_state.call_deferred(state_key)
	else:
		push_warning("No state with name %s stored in state machine" % state_key)
	

func _set_state(state_key:String) -> void:
	if current_state:
		var leave: Callable = state_dictionary[current_state].leave
		if leave.is_valid():
			leave.call()
	state_changed.emit(current_state, state_key)
	current_state = state_key
	var enter: Callable = state_dictionary[current_state].enter
	if enter.is_valid():
		enter.call()
	

## Class used by [StateMachine] in order to do some type safe stuff when adding states
class State:
	var normal: Callable
	var enter: Callable
	var leave: Callable

	func _init(_normal: Callable, _enter: Callable, _leave: Callable) -> void:
		normal = _normal
		enter = _enter
		leave = _leave
