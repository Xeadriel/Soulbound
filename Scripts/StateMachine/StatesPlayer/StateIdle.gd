class_name StateIdle extends StatePlayer

@export var SLOWDOWNSPEED : int

func physicsProcess(_delta: float) -> void:
	player.isBlocking = InputBuffer.isHeld(input.block)

	if handleActionInputs():
		pass
	elif (
		InputBuffer.isHeld(input.left) or
		InputBuffer.isHeld(input.right) or
		InputBuffer.isHeld(input.up) or
		InputBuffer.isHeld(input.down)
		):
		finished.emit(STATERUN)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, SLOWDOWNSPEED)

	if player.velocity == Vector2.ZERO:
		if player.isBlocking:
			player.blockIdleAnimation()
		else:
			player.idleAnimation()
