extends Sprite2D

signal solved(state : bool)

@onready var blueBox = $SlippyBoxPushPuzzleBoxBlue

func onBoxEnteredGoal(box):
	if box is SlippyBoxPushPuzzleBoxBlue:
		solved.emit(true)

func onBoxExitedGoal(box):
	if box is SlippyBoxPushPuzzleBoxBlue:
		solved.emit(true)

func pressUpButton():
	pass

func pressDownButton():
	pass

func pressLeftButton():
	pass

func pressRightButton():
	pass

func pressSwitchColorButton():
	pass
