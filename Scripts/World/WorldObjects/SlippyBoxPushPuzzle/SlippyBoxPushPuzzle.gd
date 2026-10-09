class_name SlippyBoxPushPuzzle extends Sprite2D
## Ice-sliding box puzzle, shown on screen while both players use the puzzle terminal.
##
## Player 1 pushes the blue box, which slides until something blocks it. Player 2
## swaps which colored blocks (green or red) are solid. The puzzle is solved when
## the box stops on the goal.
##
## The puzzle runs on a grid that is read from the child nodes when the scene
## starts, so the layout is designed in the editor by placing blocks on the grid.

signal solved(state : bool)

enum PuzzleState {
	## Hidden, ignores input.
	INACTIVE,
	## Shown and waiting for input.
	ACTIVE,
	## The box is sliding. Player 2 can still toggle the blocks; pushing waits
	## until the box stops.
	SLIDING,
	## Done for good.
	SOLVED,
}

const CELL_SIZE := 64.0
## Blocks are positioned by their top-left corner; this is the offset to their center.
const BLOCK_CENTER_OFFSET := Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
## How fast the box slides, in pixels per second.
const BOX_SPEED := 300.0
## Safety limit in case a slide is not stopped by any wall.
const MAX_SLIDE_CELLS := 100
## Tolerance for "the box has reached the next cell".
const ARRIVAL_EPSILON := 0.0001
## Half the box's size when checking whether it overlaps a block. Slightly smaller
## than half a cell, so a box resting in a cell doesn't count as touching its neighbors.
const BOX_HALF_EXTENT := 31.0

## The roles are fixed: player 1 pushes, player 2 toggles.
const PUSHER_PLAYER_INDEX := 0
const TOGGLER_PLAYER_INDEX := 1

@export var camera : AutoCamera

@onready var blueBox : SlippyBoxPushPuzzleBoxBlue = $SlippyBoxPushPuzzleBoxBlue
@onready var goal : Node2D = $SlippyBoxPushPuzzleBoxGoal
@onready var greens : Array = $Greens.get_children()
@onready var reds : Array = $Reds.get_children()

var state := PuzzleState.INACTIVE

var pusherInput := PlayerInputProfile.forPlayer(PUSHER_PLAYER_INDEX)
var togglerInput := PlayerInputProfile.forPlayer(TOGGLER_PLAYER_INDEX)

## Local position of grid cell (0, 0), which is where the box starts.
var _gridOrigin : Vector2
var _wallCells : Dictionary[Vector2i, bool] = {}
var _blockCells : Dictionary[Vector2i, SlippyBoxPushPuzzleBoxTogglable] = {}
## The cell the box is in, or the cell it is leaving while sliding.
var _boxCell : Vector2i
var _goalCell : Vector2i
var _slideDirection := Vector2i.ZERO
## How far the box has moved from _boxCell towards the next cell (0 to 1).
var _slideProgress := 0.0
var _slidCells := 0

func _ready() -> void:
	assert(camera != null, "assign the camera plz")
	for red : SlippyBoxPushPuzzleBoxTogglable in reds:
		red.toggle()

	_gridOrigin = blueBox.position
	_boxCell = _cellAt(blueBox.position)
	_goalCell = _cellAt(goal.position)
	for wall : Node2D in $Borders.get_children() + $Blacks.get_children():
		_wallCells[_cellOfBlock(wall)] = true
	for block : SlippyBoxPushPuzzleBoxTogglable in greens + reds:
		_blockCells[_cellOfBlock(block)] = block

func activate() -> void:
	if state == PuzzleState.SOLVED:
		return
	global_position = camera.global_position
	visible = true
	if state == PuzzleState.INACTIVE:
		state = PuzzleState.ACTIVE

func deactivate() -> void:
	visible = false
	if state == PuzzleState.ACTIVE:
		state = PuzzleState.INACTIVE

func _physics_process(delta: float) -> void:
	# input only while the puzzle is shown; the box keeps sliding either way
	if visible and state == PuzzleState.ACTIVE:
		if InputBuffer.consumePress(pusherInput.up):
			pushBox(Vector2i.UP)
		elif InputBuffer.consumePress(pusherInput.down):
			pushBox(Vector2i.DOWN)
		elif InputBuffer.consumePress(pusherInput.left):
			pushBox(Vector2i.LEFT)
		elif InputBuffer.consumePress(pusherInput.right):
			pushBox(Vector2i.RIGHT)

	if visible and (state == PuzzleState.ACTIVE or state == PuzzleState.SLIDING):
		if InputBuffer.consumePress(togglerInput.hit):
			toggleBlocks()

	if state == PuzzleState.SLIDING:
		_advanceSlide(delta)

## Starts sliding the box in [param direction], unless the next cell is blocked.
func pushBox(direction : Vector2i) -> void:
	if _isBlocked(_boxCell + direction):
		return
	_slideDirection = direction
	_slideProgress = 0.0
	_slidCells = 0
	state = PuzzleState.SLIDING
	blueBox.startMoving()

## Swaps which colored blocks are solid. Not possible while the box overlaps a
## colored block's cell (solid or not), because the box would end up inside a
## solid block. While sliding between two cells the box overlaps both.
func toggleBlocks() -> void:
	for cell in _occupiedCells():
		if _blockCells.has(cell):
			return
	for block : SlippyBoxPushPuzzleBoxTogglable in greens + reds:
		block.toggle()

## Moves the box along at BOX_SPEED. Whenever it reaches a cell it checks the
## next one, so blocks that became solid during the slide stop it.
func _advanceSlide(delta : float) -> void:
	# a block may have become solid right in front of the box
	if _isBlocked(_boxCell + _slideDirection):
		_slideProgress = 0.0
		blueBox.position = _positionOf(_boxCell)
		_stopBox()
		return

	var remaining := BOX_SPEED * delta / CELL_SIZE
	while remaining > 0 and state == PuzzleState.SLIDING:
		var step := minf(remaining, 1.0 - _slideProgress)
		_slideProgress += step
		remaining -= step
		if _slideProgress >= 1.0 - ARRIVAL_EPSILON:
			_boxCell += _slideDirection
			_slideProgress = 0.0
			_slidCells += 1
			if _isBlocked(_boxCell + _slideDirection) or _slidCells >= MAX_SLIDE_CELLS:
				_stopBox()
	blueBox.position = _positionOf(_boxCell) + Vector2(_slideDirection) * _slideProgress * CELL_SIZE

func _stopBox() -> void:
	_slideDirection = Vector2i.ZERO
	_slideProgress = 0.0
	# state is updated in onBoxStoppedMoving, which listens to this
	blueBox.stopMoving()

## Cells the box currently overlaps. While sliding it overlaps the cell it is
## leaving and the one it is entering, except right at the start and end.
func _occupiedCells() -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	var travelled := _slideProgress * CELL_SIZE
	if travelled - BOX_HALF_EXTENT < CELL_SIZE / 2:
		cells.append(_boxCell)
	if _slideDirection != Vector2i.ZERO and travelled + BOX_HALF_EXTENT > CELL_SIZE / 2:
		cells.append(_boxCell + _slideDirection)
	return cells

func onBoxStoppedMoving() -> void:
	if _boxCell == _goalCell:
		blueBox.solved()
		state = PuzzleState.SOLVED
		solved.emit(true)
		deactivate()
	else:
		state = PuzzleState.ACTIVE if visible else PuzzleState.INACTIVE

func _isBlocked(cell : Vector2i) -> bool:
	if _wallCells.has(cell):
		return true
	return _blockCells.has(cell) and _blockCells[cell].isSolid()

func _cellAt(localPosition : Vector2) -> Vector2i:
	return Vector2i(((localPosition - _gridOrigin) / CELL_SIZE).round())

func _cellOfBlock(block : Node2D) -> Vector2i:
	return _cellAt(to_local(block.global_position) + BLOCK_CENTER_OFFSET)

func _positionOf(cell : Vector2i) -> Vector2:
	return _gridOrigin + Vector2(cell) * CELL_SIZE
