class_name State extends Node
#base class for all states, meant to be treated as an interface

## Emitted when the state finishes and wants to transition to another state.
@warning_ignore("unused_signal")
signal finished(_next_state_path: String, _data: Dictionary)

## Called by the state machine when receiving unhandled input events.
func handleInput() -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
