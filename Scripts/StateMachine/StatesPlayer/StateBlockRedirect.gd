class_name StateBlockRedirect extends StateBlock
## Player 2's block. Tapping hit while blocking moves the block onto the partner
## and back. While redirected, the partner is protected in the direction this
## player faces, this player is unprotected and can turn to aim it.
## Every new block starts on this player.

var redirected := false

func enter(previous_state_path: String, data := {}) -> void:
	super.enter(previous_state_path, data)
	redirected = false

func handleBlockInputs() -> bool:
	if InputBuffer.consumePress(input.hit) and is_instance_valid(player.partner):
		_setRedirected(not redirected)
		return true
	return super.handleBlockInputs()

func updateFacing(direction: Vector2) -> void:
	if redirected:
		player.setPlayerDirection(direction)

func _setRedirected(on: bool) -> void:
	redirected = on
	player.isBlocking = not on
	if is_instance_valid(player.partner):
		player.partner.isShielded = on

func exit() -> void:
	if redirected:
		_setRedirected(false)
	super.exit()
