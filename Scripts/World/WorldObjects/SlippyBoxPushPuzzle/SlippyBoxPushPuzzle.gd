extends Sprite2D

signal solved(state : bool)

var goalReached : bool = false

@onready var blueBox : SlippyBoxPushPuzzleBoxBlue = $SlippyBoxPushPuzzleBoxBlue
@onready var greens = $Greens.get_children()
@onready var reds = $Reds.get_children()

@export var camera : AutoCamera

# player 1 pushes the box, player 2 toggles the colored blocks
var pusherInput := PlayerInputProfile.forPlayer(0)
var togglerInput := PlayerInputProfile.forPlayer(1)
var isSolved = false

func _ready() -> void:
	for red : SlippyBoxPushPuzzleBoxTogglable in reds:
		red.toggle()
	set_physics_process(false)
	assert(camera != null, "assign the camera plz")

func onBoxEnteredGoal(box):
	if box is SlippyBoxPushPuzzleBoxBlue:
		goalReached = true

func onBoxExitedGoal(box):
	if box is SlippyBoxPushPuzzleBoxBlue:
		goalReached = false

func onBoxStoppedMoving():
	if goalReached:
		blueBox.solved()
		solved.emit(true)
		isSolved = true
		deactivate()

func activate():
	set_physics_process(true)
	global_position = camera.global_position
	visible = true

func deactivate():
	visible = false
	set_physics_process(false)

func _physics_process(delta: float) -> void:	
	if InputBuffer.consumePress(pusherInput.up):
		blueBox.onPushedUp()
	elif InputBuffer.consumePress(pusherInput.down):
		blueBox.onPushedDown()
	elif InputBuffer.consumePress(pusherInput.left):
		blueBox.onPushedLeft()
	elif InputBuffer.consumePress(pusherInput.right):
		blueBox.onPushedRight()
	
	if InputBuffer.consumePress(togglerInput.hit):
		var cantToggleBoxes = false
		
		var blueBoxTopLeft = blueBox.global_position - Vector2(31, 31)
		var blueBoxBottomRight = blueBox.global_position + Vector2(31, 31)

		for green : SlippyBoxPushPuzzleBoxTogglable in greens:
			var greenTopLeft = green.global_position
			var greenBottomRight = green.global_position + Vector2(64, 64)

			if (
				blueBoxTopLeft.x < greenBottomRight.x and
				blueBoxBottomRight.x > greenTopLeft.x and
				blueBoxTopLeft.y < greenBottomRight.y and
				blueBoxBottomRight.y > greenTopLeft.y
			):
				return


		for red : SlippyBoxPushPuzzleBoxTogglable in reds:
			var redTopLeft = red.global_position
			var redBottomRight = red.global_position + Vector2(64, 64)

			if (
				blueBoxTopLeft.x < redBottomRight.x and
				blueBoxBottomRight.x > redTopLeft.x and
				blueBoxTopLeft.y < redBottomRight.y and
				blueBoxBottomRight.y > redTopLeft.y
			):
				return
		
		for green : SlippyBoxPushPuzzleBoxTogglable in greens:
			green.toggle()
		
		for red : SlippyBoxPushPuzzleBoxTogglable in reds:
			red.toggle()
