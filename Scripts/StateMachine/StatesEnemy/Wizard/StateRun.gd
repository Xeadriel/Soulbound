## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
extends StateEnemy

@export var SPEED : int

var runDirCooldown := 0.0
var fleeDirection := Vector2.ZERO

## Called by the state machine when receiving unhandled input events.
func handleInput() -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	runDirCooldown  -= _delta
	entity.target = getClosestPlayer()
	var distance = entity.global_position.distance_to(entity.target.global_position)

	
	# not aggroed
	if  entity.aggroRange < distance:
		fleeDirection = Vector2.ZERO
		finished.emit(IDLE)
		
	# close distance to attack
	elif entity.atkRange < distance:
		fleeDirection = Vector2.ZERO
		var direction = entity.global_position.direction_to(entity.target.global_position)
		entity.velocity = direction.normalized() * SPEED
		entity.direction = entity.getDirectionFromVector(direction)
		entity.run()
		
	# run from target
	elif runDirCooldown <= 0.0 && distance <= entity.panicRunThresholdDistance: 
		for p in players:
			var distanceToPlayer = entity.global_position.distance_to(p.global_position)
			if distanceToPlayer <= entity.panicRunThresholdDistance:
				var directionToPlayer = entity.global_position.direction_to(p.global_position)
				fleeDirection += -directionToPlayer
				var offset = randf_range(-PI/3, PI/3)
				fleeDirection = fleeDirection.rotated(offset).normalized()
				runDirCooldown = 1
				
	elif fleeDirection != Vector2.ZERO:		
		entity.velocity = fleeDirection * SPEED
		entity.direction = entity.getDirectionFromVector(fleeDirection)
		entity.run()
		
	# attacking
	elif entity.atkRange >= distance:
		fleeDirection = Vector2.ZERO
		finished.emit(TELEGRAPH)

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
