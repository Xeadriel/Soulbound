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
	## The box is sliding; input is ignored until it stops.
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
var _boxCell : Vector2i
var _goalCell : Vector2i

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

func _physics_process(_delta: float) -> void:
	if state != PuzzleState.ACTIVE:
		return

	if InputBuffer.consumePress(pusherInput.up):
		pushBox(Vector2i.UP)
	elif InputBuffer.consumePress(pusherInput.down):
		pushBox(Vector2i.DOWN)
	elif InputBuffer.consumePress(pusherInput.left):
		pushBox(Vector2i.LEFT)
	elif InputBuffer.consumePress(pusherInput.right):
		pushBox(Vector2i.RIGHT)

	if state == PuzzleState.ACTIVE and InputBuffer.consumePress(togglerInput.hit):
		toggleBlocks()

## Slides the box in [param direction] until the next cell is blocked.
func pushBox(direction : Vector2i) -> void:
	var cell := _boxCell
	for i in MAX_SLIDE_CELLS:
		if _isBlocked(cell + direction):
			break
		cell += direction
	if cell == _boxCell:
		return

	_boxCell = cell
	state = PuzzleState.SLIDING
	var target := _positionOf(cell)
	blueBox.slideTo(target, blueBox.position.distance_to(target) / BOX_SPEED)

## Swaps which colored blocks are solid. Not possible while the box sits on a
## colored block's cell, because the box would end up inside a solid block.
func toggleBlocks() -> void:
	if _blockCells.has(_boxCell):
		return
	for block : SlippyBoxPushPuzzleBoxTogglable in greens + reds:
		block.toggle()

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
