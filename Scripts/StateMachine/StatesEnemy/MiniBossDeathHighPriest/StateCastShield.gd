extends StateTelegraphSacrifice
## The cast animation is the telegraph. The shield goes up when the minion dies.

func _init() -> void:
	animation = "castShield"
	nextState = THINKING

func _onSacrifice(_sacrificePos: Vector2) -> void:
	entity.castShield()
	transition(nextState)
