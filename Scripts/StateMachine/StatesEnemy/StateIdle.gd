extends StateEnemy

@export var slowDownSpeed := 200.0
## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	entity.target = getClosestPlayer()
	var distance = getDistanceSelf2Target()
	
	if distance < entity.aggroRange:
		finished.emit(RUN)
	
	entity.velocity = entity.velocity.move_toward(Vector2.ZERO, slowDownSpeed)

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	entity.idle()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
