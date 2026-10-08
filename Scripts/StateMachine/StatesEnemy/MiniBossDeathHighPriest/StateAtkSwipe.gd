extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "swipe"
	speed = Speed.SLOW
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.swipeAtk()

func _onExit() -> void:
	entity.stopAttack()
