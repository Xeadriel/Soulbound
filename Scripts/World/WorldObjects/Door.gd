extends Node2D

var isOpen = false

func _ready() -> void:
	$PropertyInteractable.interacted.connect(interactDoor)

func _process(delta: float) -> void:
	var p1isClose = $PropertyInteractable.player1CloseEnough
	var p2isClose = $PropertyInteractable.player2CloseEnough
	if p1isClose && !p2isClose:
		$Label.visible = true
		$Label.text = "press e"
	elif !p1isClose && p2isClose:
		$Label.visible = true
		$Label.text = "press o"
	elif p1isClose && p2isClose:
		$Label.visible = true
		$Label.text = "press e or o"
	else:
		$Label.visible = false

func interactDoor():
	if isOpen:
		isOpen = false
		$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
		$TextureRect.visible = true
	else:
		isOpen = true
		$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
		$TextureRect.visible = false
