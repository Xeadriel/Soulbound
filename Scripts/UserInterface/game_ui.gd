extends Control

var pages = []
@export var current_page = 0
var currentPageIndex = 0;
var pageWidth;

func _ready() -> void:
	pageWidth = $UI1.size.x;
	
	pages = [
		$UI1,
		$UI2,
		$UI3
	];
	
	for i in pages.size():
		pages[i].position.x = i * pageWidth;
	
func _unhandled_input(event: InputEvent) -> void:
	if EventHandler.isPlayerInputJustPressed("right"):
		if(currentPageIndex < pages.size() - 1):
			currentPageIndex += 1;
			var tw = create_tween();
			tw.tween_property(self, "position:x", -currentPageIndex * pageWidth, 0.3);
	elif EventHandler.isPlayerInputJustPressed("left"):
		if(currentPageIndex > 0):
			currentPageIndex -= 1;
			var tw = create_tween();
			tw.tween_property(self, "position:x", -currentPageIndex * pageWidth, 0.3);

func _process(delta: float) -> void:
	pass

func _on_ui_1_focus_entered() -> void:
	pass

func _on_ui_2_focus_entered() -> void:
	pass 

func _on_ui_3_focus_entered() -> void:
	pass 
