class_name StateRun extends StatePlayer

@export var SPEED : int

func handleInput() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	var direction :=  Vector2(Input.get_axis(LEFT, RIGHT), Input.get_axis(UP, DOWN))
	if direction:
		player.velocity = direction.normalized() * SPEED
		setPlayerDirection(direction)
		setAttackRotationFromDirection(direction)
	else:
		finished.emit("StateIdle")
	if EventHandler.isPlayerInputJustPressed(HIT):
		finished.emit("StateAttack")
	elif EventHandler.isPlayerInputJustPressed(HEAVY_HIT):
		if player.name == "Player": finished.emit("StateHeavyAttack")
		else: finished.emit("StateChargeUpAttack")
	elif EventHandler.isPlayerInputJustPressed(BLOCK):
		finished.emit("StateBlock")
	elif EventHandler.isPlayerInputJustPressed(DASH):
		finished.emit("StateDash")
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTBOT):
		checkQuickSlotAndSwitchState(QUICKSLOTBOT)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTTOP):
		checkQuickSlotAndSwitchState(QUICKSLOTTOP)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTLEFT):
		checkQuickSlotAndSwitchState(QUICKSLOTLEFT)
	elif EventHandler.isPlayerInputJustPressed(QUICKSLOTRIGHT):
		checkQuickSlotAndSwitchState(QUICKSLOTRIGHT)

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
			finished.emit("StateWhipAttack")
		GlobalConstants.ItemIndices.NOTHING:
			return
