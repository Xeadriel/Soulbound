extends Control

var pages = []
var currentPageIndex = 0;
var pageWidth;
var cameraOffset; 

func _ready() -> void:
	pageWidth = $UI1.size.x ;
	cameraOffset = pageWidth / 2;
	
	pages = [
		$UI1,
		$UI2,
		$UI3
	];
	
	for i in pages.size():
		pages[i].position.x = i * pageWidth;

func openMenu() -> void:
	currentPageIndex = 0;
	self.position.x = -cameraOffset;
	self.visible = true;
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
			var tw = create_tween();
			tw.tween_property(self, "position:x", -currentPageIndex * pageWidth - cameraOffset, 0.3);
	elif self.visible && EventHandler.isPlayerInputJustPressed("block"):
		if(currentPageIndex > 0):
			currentPageIndex -= 1;
			var tw = create_tween();
			tw.tween_property(self, "position:x", -currentPageIndex * pageWidth - cameraOffset, 0.3);

func _on_ui_1_focus_entered() -> void:
	pass

func _on_ui_2_focus_entered() -> void:
	pass 

func _on_ui_3_focus_entered() -> void:
	pass 
