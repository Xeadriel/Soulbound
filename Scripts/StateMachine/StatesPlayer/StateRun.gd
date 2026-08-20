class_name StateRun extends StatePlayer

@export var SPEED : int

func handleInput() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	player.isBlocking = EventHandler.isPlayerInputPressed(BLOCK)

	var direction :=  Vector2(Input.get_axis(LEFT, RIGHT), Input.get_axis(UP, DOWN))
	if direction:
		player.velocity = direction.normalized() * SPEED
		setPlayerDirection(direction)
		setAttackRotationFromDirection(direction)
		if(player.isBlocking):
			player.blockRunAnimation()
		else:
			player.runAnimation()
	else:
		finished.emit(STATEIDLE)
	if EventHandler.isPlayerInputJustPressed(HIT):
		finished.emit(STATEATTACK)
	elif EventHandler.isPlayerInputJustPressed(HEAVY_HIT):
		finished.emit(STATEHEAVYATTACK)
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

func setAttackRotationFromDirection(dir: Vector2) -> void:
	assert(not dir == Vector2.ZERO, "Move direction should never be (0,0)")
	
	player.attackPivotPoint.rotation = dir.angle()

func setPlayerDirection(direction : Vector2) -> void:
	if direction.y < 0:
		player.direction = Direction.UP
	elif direction.y > 0:
		player.direction = Direction.DOWN

	# horizontal direction prioritized over vertical direction
	if direction.x < 0:
		player.direction = Direction.LEFT
	elif direction.x > 0:
		player.direction = Direction.RIGHT

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
