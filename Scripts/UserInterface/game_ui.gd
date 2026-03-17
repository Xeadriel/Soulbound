extends Control

var pages = []
var currentPageIndex = 0;
var pageWidth;
var cameraOffset;

func _ready() -> void:
	pageWidth = $Inventory.size.x ;
	cameraOffset = pageWidth / 2;
	
	pages = [
		$Inventory,
		$UI2,
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

func closeMenu() -> void:
	self.visible = false;
	get_tree().paused = false;

func _process(delta: float) -> void:
	if EventHandler.isPlayerInputJustPressed("pause"):
		if(self.visible):
			closeMenu();
		else:
			openMenu();
	elif self.visible && EventHandler.isPlayerInputJustPressed("interact"):
		if(currentPageIndex < pages.size() - 1):
			currentPageIndex += 1;
			pages[currentPageIndex].grab_focus()
			var tw = create_tween();
			tw.tween_property(self, "position:x", 
			-currentPageIndex * pageWidth - cameraOffset, 
			0.3);
	elif self.visible && EventHandler.isPlayerInputJustPressed("block"):
		if(currentPageIndex > 0):
			currentPageIndex -= 1;
			pages[currentPageIndex].grab_focus()
			var tw = create_tween();
			tw.tween_property(self, 
			"position:x", -currentPageIndex * pageWidth - cameraOffset, 
			0.3);
