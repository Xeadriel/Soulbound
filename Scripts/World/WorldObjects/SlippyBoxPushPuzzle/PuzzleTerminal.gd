class_name PuzzleTerminal extends WorldObject

# player 1 and 2
var whoActivated = [false, false]

signal start
signal stop

# playerNumber needs to be either 0 or 1
func onInteract(playerNumber):
	# if interact is called but both are already activated that means one player is leaving
	# and puzzle should be hidden again
	if whoActivated[0] and whoActivated[1]:
		stop.emit()
	
	whoActivated[playerNumber] = not whoActivated[playerNumber]
	
	if whoActivated[0] and whoActivated[1]:
		start.emit()

func onPuzzleSolved(state: bool) -> void:
	$PropertyInteractable.process_mode = Node.PROCESS_MODE_DISABLED

