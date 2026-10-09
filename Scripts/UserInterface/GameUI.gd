extends Control
## Pause menu with pages (inventory, map, ...) that slide sideways.
## Pause opens/closes it, interact goes to the next page, block to the previous one.

## How long sliding to another page takes, in seconds.
const PAGE_SLIDE_DURATION := 0.3
const SEEN_ROOM_COLOR := Color(0.329, 0.329, 0.329)
const CURRENT_ROOM_COLOR := Color(1, 1, 1)

@onready var inventory : Inventory = $Inventory
@onready var dungeonMapNode : Panel = $Map/MarginContainer/VBoxContainer/MapPanel/Dungeon
@onready var currentRoomSign : Control = $Map/MarginContainer/VBoxContainer/MapPanel/Dungeon/CurrentLocationSign
@onready var pages : Array[Control] = [$Inventory, $Map, $UI3]

var currentPageIndex := 0
var pageSlide : Tween

var p1Input := PlayerInputProfile.forPlayer(0)
var p2Input := PlayerInputProfile.forPlayer(1)

func _ready() -> void:
	for page in pages:
		page.focus_mode = Control.FOCUS_ALL
	resized.connect(layoutPages)
	layoutPages()

## Lines the pages up side by side, one screen width apart, and shows the current one.
func layoutPages() -> void:
	if pageSlide:
		pageSlide.kill()
	for i in pages.size():
		pages[i].position.x = i * size.x
	position.x = -currentPageIndex * size.x

func openMenu() -> void:
	currentPageIndex = 0
	layoutPages()
	pages[currentPageIndex].grab_focus()
	visible = true
	inventory.updateInventoryState()
	get_tree().paused = true
	updateMapState()

func closeMenu() -> void:
	visible = false
	get_tree().paused = false

## Shows the seen rooms on the map and marks the current one.
## Map sprites are named like the rooms in the world.
func updateMapState() -> void:
	var session := GlobalStates.session
	for roomName in session.seenRooms:
		var roomSprite := _mapSprite(roomName)
		if roomSprite != null:
			roomSprite.self_modulate = SEEN_ROOM_COLOR
			roomSprite.visible = true

	var currentSprite := _mapSprite(session.currentRoom)
	currentRoomSign.visible = currentSprite != null
	if currentSprite != null:
		currentSprite.self_modulate = CURRENT_ROOM_COLOR
		currentRoomSign.position = currentSprite.position - currentRoomSign.size / 2

func _mapSprite(roomName : String) -> AnimatedSprite2D:
	if roomName.is_empty():
		return null
	var sprite := dungeonMapNode.get_node_or_null(NodePath(roomName)) as AnimatedSprite2D
	if sprite == null:
		push_warning("Room \"%s\" has no sprite on the menu map" % roomName)
	return sprite

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
	if pageSlide:
		pageSlide.kill()
	pageSlide = create_tween()
	pageSlide.tween_property(self, "position:x", -currentPageIndex * size.x, PAGE_SLIDE_DURATION)
