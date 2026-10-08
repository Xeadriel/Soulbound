extends Control

var pages = []
var currentPageIndex = 0;
var pageWidth;
var cameraOffset;

var p1Input := PlayerInputProfile.forPlayer(0)
var p2Input := PlayerInputProfile.forPlayer(1)

func _ready() -> void:
	pageWidth = $Inventory.size.x ;
	cameraOffset = pageWidth / 2;
	
	pages = [
		$Inventory,
		$Map,
		$UI3
	];
	
	for i in pages.size():
		pages[i].focus_mode = Control.FOCUS_ALL
		pages[i].position.x = i * pageWidth

func openMenu() -> void:
	currentPageIndex = 0;
	self.position.x = -cameraOffset;
	pages[currentPageIndex].grab_focus()
	self.visible = true;
	$Inventory.updateInventoryState()
	get_tree().paused = true;
	updateMapState()

func closeMenu() -> void:
	self.visible = false;
	get_tree().paused = false;
	
func updateMapState():
	var dungeonMapNode: Panel = $Map/MarginContainer/VBoxContainer/MapPanel/Dungeon
	var pointers: Node = $Map/MarginContainer/VBoxContainer/MapPanel/Dungeon/pointers
	for key in GlobalStates.seenRooms:
		var roomNode: AnimatedSprite2D = dungeonMapNode.get_child(GlobalStates.seenRooms[key])
		roomNode.self_modulate = Color(0.329, 0.329, 0.329)
		roomNode.visible = true
	for p in pointers.get_children():
		p.visible = false
	pointers.get_child(GlobalStates.lastRoomVisited).visible = true
	dungeonMapNode.get_child(GlobalStates.lastRoomVisited).self_modulate = Color(1, 1, 1)
	
func _process(delta: float) -> void:
	if InputBuffer.consumePress(p1Input.pause):
		if(self.visible):
			closeMenu();
		else:
			openMenu();
	elif self.visible && (InputBuffer.consumePress(p1Input.interact) || InputBuffer.consumePress(p2Input.interact)):
		if(currentPageIndex < pages.size() - 1):
			currentPageIndex += 1;
			pages[currentPageIndex].grab_focus()
			var tw = create_tween();
			tw.tween_property(self, "position:x", 
			-currentPageIndex * pageWidth - cameraOffset, 
			0.3);
	elif self.visible && (InputBuffer.consumePress(p1Input.block) || InputBuffer.consumePress(p2Input.block)):
		if(currentPageIndex > 0):
			currentPageIndex -= 1;
			pages[currentPageIndex].grab_focus()
			var tw = create_tween();
			tw.tween_property(self, 
			"position:x", -currentPageIndex * pageWidth - cameraOffset, 
			0.3);
