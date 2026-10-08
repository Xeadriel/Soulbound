class_name StateRun extends StatePlayer

@export var SPEED : int

## Movement speed multiplier while blocking.
const BLOCKING_SPEED_FACTOR := 0.2

func physicsProcess(_delta: float) -> void:
	player.isBlocking = InputBuffer.isHeld(input.block)

	var direction := input.moveVector()
	if direction:
		if player.isBlocking:
			player.blockRunAnimation()
			player.velocity = direction.normalized() * SPEED * BLOCKING_SPEED_FACTOR
		else:
			player.runAnimation()
			player.velocity = direction.normalized() * SPEED
			# facing stays locked while blocking
			player.setPlayerDirection(direction)
		player.setAttackRotationFromDirection(direction)
	else:
		finished.emit(STATEIDLE)

	handleActionInputs()
