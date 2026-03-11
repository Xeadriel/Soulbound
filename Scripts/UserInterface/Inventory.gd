extends Control

@export var columns = 7
@export var rows = 3
#player number starts from 0
var selectedPlayerIndex = [0, 0]

func _ready() -> void:
	updateSelector()

func _process(delta: float) -> void:
	if EventHandler.isPlayerInputJustPressed("right"):
		moveSelector(1, 0, 0)
	elif EventHandler.isPlayerInputJustPressed("left"):
		moveSelector(-1, 0, 0)
	elif EventHandler.isPlayerInputJustPressed("up"):
		moveSelector(0, -1, 0)
	elif EventHandler.isPlayerInputJustPressed("down"):
		moveSelector(0, 1, 0)
	elif EventHandler.isPlayerInputJustPressed("left2"):
		moveSelector(-1, 0, 1)
	elif EventHandler.isPlayerInputJustPressed("up2"):
		moveSelector(0, -1, 1)
	elif EventHandler.isPlayerInputJustPressed("down2"):
		moveSelector(0, 1, 1)
	elif EventHandler.isPlayerInputJustPressed("right2"):
		moveSelector(1, 0, 1)
		
func moveSelector(dx: int, dy: int, playerNumber: int) -> void:
	
	var row = selectedPlayerIndex[playerNumber] / columns
	var col = selectedPlayerIndex[playerNumber] % columns
	col += dx
	row += dy
	row = clamp(row, 0, rows - 1)
	col = clamp(col, 0, columns - 1)
	selectedPlayerIndex[playerNumber] = row * columns + col
	updateSelector()

func updateSelector():
	var gc = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer
	for i in gc.get_child_count():
		var slot = gc.get_child(i)
		if selectedPlayerIndex[0] == i:
			slot.modulate = Color(0, 0, 1)
		elif selectedPlayerIndex[1] == i:
			slot.modulate = Color(1, 0, 0)
		elif selectedPlayerIndex[0] != i && selectedPlayerIndex[1] != i:
			slot.modulate = Color(0.3, 0.3, 0.3)
