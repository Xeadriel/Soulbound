class_name SlippyBoxPushPuzzleBoxBlue extends CharacterBody2D
## The box player 1 pushes. SlippyBoxPushPuzzle moves it and decides where it stops.

signal stoppedMoving
signal startedMoving

var moving : bool = false

func startMoving() -> void:
	moving = true
	startedMoving.emit()

func stopMoving() -> void:
	moving = false
	stoppedMoving.emit()

func solved() -> void:
	set_physics_process(false)
