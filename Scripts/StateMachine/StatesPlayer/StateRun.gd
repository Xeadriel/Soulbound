class_name StateRun extends StatePlayer

@export var SPEED : int

func physicsProcess(_delta: float) -> void:
	var direction := input.moveVector()
	if direction:
		player.runAnimation()
		player.velocity = direction.normalized() * SPEED
		player.setPlayerDirection(direction)
		player.setAttackRotationFromDirection(direction)
	else:
		# an action pressed this frame stays buffered and is handled by StateIdle
		transition(STATEIDLE)
		return

	if handleActionInputs():
		pass
	elif InputBuffer.isHeld(input.block):
		transition(STATEBLOCK)
