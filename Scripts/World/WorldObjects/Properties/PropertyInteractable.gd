class_name PropertyInteractable extends Area2D

var player1CloseEnough = false
var player2CloseEnough = false

func onBodyEntered(body: Node2D) -> void:
	if body is Player:
		body.setInteractable(get_parent())
		if body is Player1:
			player1CloseEnough = true
		elif body is Player2:
			player2CloseEnough = true
		else:
			printerr("wtf? wrong player name")

func onBodyExited(body: Node2D) -> void:
	if body is Player:
		body.setInteractable(null)
		if body.name == "Player":
			player1CloseEnough = false
		elif body.name == "Player2":
			player2CloseEnough = false
		else:
			printerr("wtf? wrong player name")
