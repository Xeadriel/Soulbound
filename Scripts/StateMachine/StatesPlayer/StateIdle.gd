class_name StateIdle extends StatePlayer

@export var SLOWDOWNSPEED : int

func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	if EventHandler.isPlayerInputJustPressed(HIT):
		finished.emit(STATEATTACK)
	elif EventHandler.isPlayerInputJustPressed(HEAVY_HIT):
		finished.emit(STATEHEAVYATTACK)
	elif EventHandler.isPlayerInputJustPressed(BLOCK):
		finished.emit(STATEBLOCK)
	elif EventHandler.isPlayerInputJustPressed(DASH):
		finished.emit(STATEDASH)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTBOT):
		checkQuickSlotAndSwitchState(QUICKSLOTBOT)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTTOP):
		checkQuickSlotAndSwitchState(QUICKSLOTTOP)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTLEFT):
		checkQuickSlotAndSwitchState(QUICKSLOTLEFT)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTRIGHT):
		checkQuickSlotAndSwitchState(QUICKSLOTRIGHT)
	elif EventHandler.isPlayerInputJustPressed(INTERACT):
		if player.interactableObject == null:
			pass
		elif player.interactableObject is PuzzleTerminal:
				player.interactableObject.onInteract(0 if player is Player1 else 1)
				finished.emit(STATEINTERACTING)
		else:
			player.interactableObject.onInteract(0 if player is Player1 else 1)
	elif (
		EventHandler.isPlayerInputPressed(LEFT) or
		EventHandler.isPlayerInputPressed(RIGHT) or
		EventHandler.isPlayerInputPressed(UP) or
		EventHandler.isPlayerInputPressed(DOWN)
		):
		finished.emit(STATERUN)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, SLOWDOWNSPEED)

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass

func checkQuickSlotAndSwitchState(quickSlotInput : String):
	var index = 0
	
	# choose correct index
	match quickSlotInput:
		QUICKSLOTBOT:
			index = GlobalConstants.QuickSlotIndices.BOTTOM
		QUICKSLOTTOP:
			index = GlobalConstants.QuickSlotIndices.TOP
		QUICKSLOTLEFT:
			index = GlobalConstants.QuickSlotIndices.LEFT
		QUICKSLOTRIGHT:
			index = GlobalConstants.QuickSlotIndices.RIGHT
	
	if not player.canQuickSlotItemBeUsed(index): return
	
	var id : GlobalConstants.ItemIndices = player.getQuickSlotItemID(index)
	
	match id:
		GlobalConstants.ItemIndices.NOTHING:
			return
		GlobalConstants.ItemIndices.WHIP:
			finished.emit(STATEWHIPATTACK)
		GlobalConstants.ItemIndices.NOTHING:
			return
