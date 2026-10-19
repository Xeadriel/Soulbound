extends StateEnemyAnimated

func _init() -> void:
	animation = "telegraphSwipe"
	faceTarget = true
	nextState = SWIPE
