extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "castShield"
	speed = Speed.TELEGRAPH_TIME
	acquireTarget = false
	stopMoving = false
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.castShieldAnimation()

func _onAnimationDone() -> void:
	entity.castShield()
	transition(nextState)
