class_name StateIdle extends StatePlayer

@export var SLOWDOWNSPEED : int

func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	if EventHandler.isPlayerInputJustPressed(HIT):
		finished.emit("StateAttack")
	elif EventHandler.isPlayerInputJustPressed(HEAVY_HIT):
		finished.emit("StateHeavyAttack")
	elif EventHandler.isPlayerInputJustPressed(BLOCK):
		finished.emit("StateBlock")
	elif (
		EventHandler.isPlayerInputPressed(LEFT) or
		EventHandler.isPlayerInputPressed(RIGHT) or
		EventHandler.isPlayerInputPressed(UP) or
		EventHandler.isPlayerInputPressed(DOWN)
		):
		finished.emit("StateRun")
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, SLOWDOWNSPEED)

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass
