## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
extends StateNamesMiniBossDeathHighPriest

@export var SPEED : int

var runDirCooldown := 0.0
var strafeDistance := 100.0

## Called by the state machine when receiving unhandled input events.
func handleInput() -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	runDirCooldown  -= _delta
	
	# get direction to player
	entity.target = getClosestPlayer()
	var targetDirection = entity.target.global_position - entity.global_position
	var distance = entity.global_position.distance_to(entity.target.global_position)
	
	# strafe direction 
	var strafeDirection = Vector2(-targetDirection.y, targetDirection.x)
	var distanceDiff = distance - strafeDistance
	
	
	

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
