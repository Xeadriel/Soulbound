extends Sprite2D

signal solved(state : bool)

@onready var blueBox : SlippyBoxPushPuzzleBoxBlue = $SlippyBoxPushPuzzleBoxBlue
@onready var greens = $Greens.get_children()
@onready var reds = $Reds.get_children()

func _ready() -> void:
	for red : SlippyBoxPushPuzzleBoxTogglable in reds:
		red.toggle()

func onBoxEnteredGoal(box):
	if box is SlippyBoxPushPuzzleBoxBlue:
		solved.emit(true)

func onBoxExitedGoal(box):
	if box is SlippyBoxPushPuzzleBoxBlue:
		solved.emit(true)

func pressUpButton(state : bool):
	if state:
		blueBox.onPushedUp()

func pressDownButton(state : bool):
	if state:
		blueBox.onPushedDown()

func pressLeftButton(state : bool):
	if state:
		blueBox.onPushedLeft()

func pressRightButton(state : bool):
	if state:
		blueBox.onPushedRight()

func pressSwitchColorButton(state : bool):
	for green : SlippyBoxPushPuzzleBoxTogglable in greens:
		green.toggle()
	
	for red : SlippyBoxPushPuzzleBoxTogglable in reds:
		red.toggle()
