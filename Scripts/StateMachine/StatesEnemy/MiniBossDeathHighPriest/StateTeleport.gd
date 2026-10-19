extends StateEnemyAnimated

func _init() -> void:
	animation = "teleport"
	nextState = THINKING

func _onAnimationDone() -> void:
	entity.teleport()
	transition(nextState)
