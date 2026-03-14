extends Node

var playerInputs = {
	"up" : false, 
	"down" : false,
	"left" : false,
	"right" : false,
	"hit" : false,
	"heavyHit" : false,
	"block" : false,
	"dash" : false,
	"up2" : false, 
	"down2" : false,
	"left2" : false,
	"right2" : false,
	"hit2" : false,
	"heavyHit2" : false,
	"block2" : false,
	"pause" : false,
	"pause2" : false,
	"dash2" : false,
	"interact": false,
	"interact2": false,
	"quickSlotBottom": false,
	"quickSlotTop": false,
	"quickSlotLeft": false,
	"quickSlotRight": false,
	"quickSlotBottom2": false,
	"quickSlotTop2": false,
	"quickSlotLeft2": false,
	"quickSlotRight2": false,
	"uiScrollLeft": false,
	"uiScrollRight": false,
	"uiScrollLeft2": false,
	"uiScrollRight2": false
	}

var playerInputsJustPressed = {
	"up" : false, 
	"down" : false,
	"left" : false,
	"right" : false,
	"hit" : false,
	"heavyHit" : false,
	"block" : false,
	"dash" : false,
	"up2" : false, 
	"down2" : false,
	"left2" : false,
	"right2" : false,
	"hit2" : false,
	"heavyHit2" : false,
	"block2" : false,
	"pause" : false,
	"pause2" : false,
	"dash2" : false,
	"interact": false,
	"interact2": false,
	"quickSlotBottom": false,
	"quickSlotTop": false,
	"quickSlotLeft": false,
	"quickSlotRight": false,
	"quickSlotBottom2": false,
	"quickSlotTop2": false,
	"quickSlotLeft2": false,
	"quickSlotRight2": false,
	"uiScrollLeft": false,
	"uiScrollRight": false,
	"uiScrollLeft2": false,
	"uiScrollRight2": false
	}

# item signals
signal name1
signal name2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func playerDied(playerNumber):
	pass

func _unhandled_input(event: InputEvent) -> void:

	for input in playerInputs.keys():
		if not event.is_action(input):
			continue

		if event.is_pressed() and not playerInputs[input]:
			playerInputs[input] = true
			playerInputsJustPressed[input] = true
		elif event.is_released():
			playerInputs[input] = false
			playerInputsJustPressed[input] = false
		elif event.is_pressed():
			playerInputsJustPressed[input] = false
		
		break

func isPlayerInputJustPressed(input : String):
	var pressed = playerInputsJustPressed[input]
	playerInputsJustPressed[input] = false
	return pressed

func isPlayerInputPressed(input : String):
	return playerInputs[input]

func itemPickedUp(itemIndex):
	pass

func itemEquipped(quickSlotIndex):
	pass
