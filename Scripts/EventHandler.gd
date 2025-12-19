extends Node

var playerInputs = {
	"up" : false, 
	"down" : false,
	"left" : false,
	"right" : false,
	"hit" : false,
	"heavyHit" : false,
	"block" : false,
	"up2" : false, 
	"down2" : false,
	"left2" : false,
	"right2" : false,
	"hit2" : false,
	"heavyHit2" : false,
	"block2" : false
	}

var playerInputsJustPressed = {
	"up" : false, 
	"down" : false,
	"left" : false,
	"right" : false,
	"hit" : false,
	"heavyHit" : false,
	"block" : false,
	"up2" : false, 
	"down2" : false,
	"left2" : false,
	"right2" : false,
	"hit2" : false,
	"heavyHit2" : false,
	"block2" : false
	}

func playerDied(playerNumber):
	#print("player " + str(playerNumber) + " is ded")
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
