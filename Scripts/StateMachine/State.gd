class_name State extends Node
## Base class for all states. Override the methods you need.

## Emitted when the state finishes and wants to transition to another state.
@warning_ignore("unused_signal")
signal finished(_next_state_path: String, _data: Dictionary)

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

## Called by the state machine when the owner's AnimatedSprite2D finishes an
## animation while this state is active.
func onAnimationFinished(_animationName: String) -> void:
	pass
