class_name PropertyInteractable extends Area2D

var player1CloseEnough = false
var player2CloseEnough = false

signal interacted

func _process(delta: float) -> void:
	if player1CloseEnough:
		if EventHandler.isPlayerInputJustPressed("interact"):
			interacted.emit()
	elif player2CloseEnough:
		if EventHandler.isPlayerInputJustPressed("interact2"):
			interacted.emit()

func onBodyEntered(body: Node2D) -> void:
	if body is Player:
		if body.name == "Player":
			player1CloseEnough = true
		elif body.name == "Player2":
			player2CloseEnough = true
		else:
			printerr("wtf? wrong player name")

func onBodyExited(body: Node2D) -> void:
	if body is Player:
		if body.name == "Player":
			player1CloseEnough = false
		elif body.name == "Player2":
			player2CloseEnough = false
		else:
			printerr("wtf? wrong player name")
