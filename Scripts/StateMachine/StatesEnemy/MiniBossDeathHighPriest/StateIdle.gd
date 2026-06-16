extends StateEnemy

var idleDuration: float = 2.0

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	idleDuration -= _delta
	if(idleDuration <= 0):
		finished.emit(THINKING)

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
