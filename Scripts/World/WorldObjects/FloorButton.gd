class_name FloorButton extends WorldObject

signal triggered(state : bool)

func onEntered():
	triggered.emit(true)

func onExited():
	triggered.emit(false)
