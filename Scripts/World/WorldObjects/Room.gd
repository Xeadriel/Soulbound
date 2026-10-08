class_name Room extends Node2D

var enteredFirstTime = false
signal activate

func _ready():
	process_mode = PROCESS_MODE_DISABLED

func updateRoomStatus():
	GlobalStates.lastRoomVisited = self.get_index()
	GlobalStates.seenRooms[self.name] = self.get_index()
	
	if not enteredFirstTime:
		activate.emit()
	enteredFirstTime = true
	process_mode = PROCESS_MODE_INHERIT
