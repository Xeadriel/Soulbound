## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
class_name StateRunGoblin extends StateEnemy

@export var SPEED : int

## Called by the state machine when receiving unhandled input events.
func handleInput() -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	entity.target = getClosestPlayer()
	var distance = entity.global_position.distance_to(entity.target.global_position)
	if  entity.aggroRange < distance:
		finished.emit(IDLE)
	elif entity.atkRange <= distance:
		var direction = entity.global_position.direction_to(entity.target.global_position)
		entity.velocity = direction.normalized() * SPEED
		entity.direction = entity.getDirectionFromVector(direction)
		entity.run()
	else:
		finished.emit(RUNCIRCLE)

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
