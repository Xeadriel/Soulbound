class_name StateInteracting extends StatePlayer


func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	if EventHandler.isPlayerInputJustPressed(INTERACT):
		finished.emit(STATEIDLE)
	
	if player.interactableObject is PuzzleTerminal:
		if EventHandler.isPlayerInputJustPressed(INTERACT):
			player.interactableObject.onInteract(0 if player is Player1 else 1)
	
	if player.interactableObject == null:
		finished.emit(STATEIDLE)

func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity = Vector2.ZERO
	# add interacting animation
	# could make this a general purpose thing based on data from transition here
	pass

func exit() -> void:
	pass
