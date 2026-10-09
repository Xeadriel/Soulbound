class_name PuzzleTerminal extends WorldObject

# player 1 and 2
var whoActivated = [false, false]

signal start
signal stop

func onInteract(playerIndex: int) -> void:
	whoActivated[playerIndex] = not whoActivated[playerIndex]

	if not (whoActivated[0] and whoActivated[1]):
		stop.emit()
	
	if whoActivated[0] and whoActivated[1]:
		start.emit()

func onPuzzleSolved(state: bool) -> void:
	$PropertyInteractable.process_mode = Node.PROCESS_MODE_DISABLED

