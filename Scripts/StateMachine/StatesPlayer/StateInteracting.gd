class_name StateInteracting extends StatePlayer

func physicsProcess(_delta: float) -> void:
	var object : WorldObject = player.interactableObject
	if InputBuffer.consumePress(input.interact):
		if object != null and object.locksPlayerWhileInteracting:
			object.onInteract(player.playerIndex)
		transition(STATEIDLE)

	if player.interactableObject == null:
		transition(STATEIDLE)

func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity = Vector2.ZERO
	# add interacting animation
	# could make this a general purpose thing based on data from transition here
