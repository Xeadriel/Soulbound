class_name StateIdle extends StatePlayer

@export var SLOWDOWNSPEED : int

func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	if Input.is_action_just_pressed(HIT):
		finished.emit("StateAttack")
	elif Input.is_action_just_pressed(BLOCK):
		finished.emit("StateBlock")
	elif (
		Input.is_action_pressed(LEFT) or
		Input.is_action_pressed(RIGHT) or
		Input.is_action_pressed(UP) or
		Input.is_action_pressed(DOWN)
		):
		finished.emit("StateRun")
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, SLOWDOWNSPEED)

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass
