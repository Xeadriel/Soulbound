class_name StateBlock extends StatePlayer
## Holding block, standing or moving. Facing stays locked and attacks are disabled;
## dash, quick slots and interact still work.

## Movement speed while blocking.
@export var SPEED : int

func enter(_previous_state_path: String, _data := {}) -> void:
	player.isBlocking = true
	# attack presses buffered in an earlier state should not fire later
	discardAttackInputs()

func physicsProcess(_delta: float) -> void:
	var direction := input.moveVector()
	if not InputBuffer.isHeld(input.block):
		transition(STATERUN if direction else STATEIDLE)
		return

	if direction:
		player.velocity = direction.normalized() * SPEED
		player.setAttackRotationFromDirection(direction)
		updateFacing(direction)
	else:
		player.velocity = Vector2.ZERO
	player.blockIdleAnimation()

	handleBlockInputs()

## Facing stays locked while blocking. Override to let the player turn.
func updateFacing(_direction: Vector2) -> void:
	pass

## Handles the buttons pressed while blocking. Returns true if one was used.
func handleBlockInputs() -> bool:
	discardAttackInputs()
	return handleUtilityInputs()

func exit() -> void:
	player.isBlocking = false
