class_name StateRun extends StatePlayer

@export var SPEED : int

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func handleInput() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	if EventHandler.isPlayerInputJustPressed(HIT):
		finished.emit("StateAttack")
	elif EventHandler.isPlayerInputJustPressed(BLOCK):
		finished.emit("StateBlock")
		
	var direction :=  Vector2(Input.get_axis(LEFT, RIGHT), Input.get_axis(UP, DOWN))
	if direction:
		player.velocity = direction.normalized() * SPEED
		setPlayerDirection(direction)
		setAttackRotationFromDirection(direction)
	else:
		finished.emit("StateIdle")

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
