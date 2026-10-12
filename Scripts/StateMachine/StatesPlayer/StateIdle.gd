class_name StateIdle extends StatePlayer

@export var SLOWDOWNSPEED : int

func physicsProcess(_delta: float) -> void:
	if handleActionInputs():
		pass
	elif InputBuffer.isHeld(input.block):
		transition(STATEBLOCK)
	elif (
		InputBuffer.isHeld(input.left) or
		InputBuffer.isHeld(input.right) or
		InputBuffer.isHeld(input.up) or
		InputBuffer.isHeld(input.down)
		):
		transition(STATERUN)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, SLOWDOWNSPEED)

	# left the state: don't override the new state's animation
	if not isActive:
		return

	if player.velocity == Vector2.ZERO:
		player.idleAnimation()
