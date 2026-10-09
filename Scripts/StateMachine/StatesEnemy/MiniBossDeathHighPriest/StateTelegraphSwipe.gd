extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "telegraphSwipe"
	speed = Speed.TELEGRAPH_TIME
	telegraphTimeOverride = 2.0
	faceTarget = true
	nextState = SWIPE

func _onEnter(_data: Dictionary) -> void:
	entity.telegraphSwipe()
