extends Control
## Pause menu with pages (inventory, map, ...) that slide sideways.
## Pause opens/closes it, interact goes to the next page, block to the previous one.

## How long sliding to another page takes, in seconds.
const PAGE_SLIDE_DURATION := 0.3
const SEEN_ROOM_COLOR := Color(0.329, 0.329, 0.329)
const CURRENT_ROOM_COLOR := Color(1, 1, 1)

@onready var inventory : Inventory = $Inventory
@onready var dungeonMapNode : Panel = $Map/MarginContainer/VBoxContainer/MapPanel/Dungeon
@onready var pointers : Node = $Map/MarginContainer/VBoxContainer/MapPanel/Dungeon/pointers
@onready var pages : Array[Control] = [$Inventory, $Map, $UI3]

var currentPageIndex := 0
var pageWidth : float
var cameraOffset : float

var p1Input := PlayerInputProfile.forPlayer(0)
var p2Input := PlayerInputProfile.forPlayer(1)

func _ready() -> void:
	pageWidth = inventory.size.x
	cameraOffset = pageWidth / 2

	for i in pages.size():
		pages[i].focus_mode = Control.FOCUS_ALL
		pages[i].position.x = i * pageWidth

func openMenu() -> void:
	currentPageIndex = 0
	position.x = -cameraOffset
	pages[currentPageIndex].grab_focus()
	visible = true
	inventory.updateInventoryState()
	get_tree().paused = true
	updateMapState()

func closeMenu() -> void:
	visible = false
	get_tree().paused = false

func updateMapState() -> void:
	var session := GlobalStates.session
	for key in session.seenRooms:
		var roomNode : AnimatedSprite2D = dungeonMapNode.get_child(session.seenRooms[key])
		roomNode.self_modulate = SEEN_ROOM_COLOR
		roomNode.visible = true
	for p in pointers.get_children():
		p.visible = false
	pointers.get_child(session.lastRoomVisited).visible = true
	dungeonMapNode.get_child(session.lastRoomVisited).self_modulate = CURRENT_ROOM_COLOR

func _process(_delta: float) -> void:
	if InputBuffer.consumePress(p1Input.pause):
		if visible:
			closeMenu()
		else:
			openMenu()
	elif visible && (InputBuffer.consumePress(p1Input.interact) || InputBuffer.consumePress(p2Input.interact)):
		if currentPageIndex < pages.size() - 1:
			showPage(currentPageIndex + 1)
	elif visible && (InputBuffer.consumePress(p1Input.block) || InputBuffer.consumePress(p2Input.block)):
		if currentPageIndex > 0:
			showPage(currentPageIndex - 1)

## Slides the menu to the page with the given index and focuses it.
func showPage(index : int) -> void:
	currentPageIndex = index
	pages[currentPageIndex].grab_focus()
	var tw := create_tween()
	tw.tween_property(self, "position:x", -currentPageIndex * pageWidth - cameraOffset, PAGE_SLIDE_DURATION)
