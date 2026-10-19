class_name StateTelegraphSacrifice extends StateEnemyAnimated
## Telegraph of a miniboss ability that costs a minion. Entering marks a random
## minion in the room, so players see who is about to die while the boss's
## animation shows which ability is coming. When the telegraph ends the minion
## dies and the ability goes off in the same frame (_onSacrifice).
## If the minion dies first, the ability is cancelled.

func enter(previous_state_path: String, data := {}) -> void:
	if not entity.markSacrifice():
		transition(THINKING)
		return
	super.enter(previous_state_path, data)

func physicsProcess(_delta: float) -> void:
	if not entity.isSacrificeAlive():
		_onCancelled()
		transition(THINKING)

func _onAnimationDone() -> void:
	if not entity.isSacrificeAlive():
		_onCancelled()
		transition(THINKING)
		return
	_onSacrifice(entity.performSacrifice())

## The minion just died and the ability goes off. [param sacrificePos] is where it stood.
func _onSacrifice(sacrificePos: Vector2) -> void:
	transition(nextState, {"sacrificePos": sacrificePos})

## The minion died before the telegraph ended. Undo what the telegraph started.
func _onCancelled() -> void:
	pass

func _onExit() -> void:
	# still marked if the telegraph was left early
	entity.clearSacrifice()
