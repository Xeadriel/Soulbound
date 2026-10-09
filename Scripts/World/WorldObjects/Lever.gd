class_name Lever extends WorldObject

var leverState = false
signal leverFlipped(state : bool)

func onInteract(_playerIndex: int) -> void:
	leverState = not leverState
	match leverState:
		true:
			play("on")
			leverFlipped.emit(true)
		false:
			play("off")
			leverFlipped.emit(false)
