class_name SlippyBoxPushPuzzleBoxBlue extends CharacterBody2D
## The box player 1 pushes. SlippyBoxPushPuzzle decides where it slides to.

signal stoppedMoving
signal startedMoving

var moving : bool = false

## Slides to [param target] (local position) at constant speed.
func slideTo(target : Vector2, duration : float) -> void:
	moving = true
	startedMoving.emit()
	var tween := create_tween()
	tween.tween_property(self, "position", target, duration)
	await tween.finished
	moving = false
	stoppedMoving.emit()

func solved() -> void:
	set_physics_process(false)
