class_name PuzzleTerminal extends WorldObject

# player 1 and 2
var whoActivated = [false, false]

signal start
signal stop

# playerNumber needs to be either 0 or 1
func onInteract(playerNumber):
	whoActivated[playerNumber] = not whoActivated[playerNumber]

	if not (whoActivated[0] and whoActivated[1]):
		stop.emit()
	
	if whoActivated[0] and whoActivated[1]:
		start.emit()

func onPuzzleSolved(state: bool) -> void:
	$PropertyInteractable.process_mode = Node.PROCESS_MODE_DISABLED

