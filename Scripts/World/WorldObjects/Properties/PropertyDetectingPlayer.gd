extends Area2D

var isPlayer1Inside = false
var isPlayer2Inside2 = false

signal detected

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		if body is Player1:
			isPlayer1Inside = true
			EventHandler.player1Entered.emit(self)
			detected.emit()
		elif body is Player2:
			isPlayer2Inside2 = true
			EventHandler.player2Entered.emit(self)
			detected.emit()
	if isPlayer1Inside && isPlayer2Inside2:
		EventHandler.bothPlayersEntered.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		if body is Player1:
			isPlayer1Inside = false
			EventHandler.player1Exited.emit(self)
			detected.emit()
		elif body is Player2:
			isPlayer2Inside2 = false
			EventHandler.player2Exited.emit(self)
			detected.emit()
	if !isPlayer1Inside && !isPlayer2Inside2:
		EventHandler.bothPlayersExited.emit(self)
