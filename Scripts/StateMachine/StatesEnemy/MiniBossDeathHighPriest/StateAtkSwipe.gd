extends StateEnemyAnimated

func _init() -> void:
	animation = "swipe"
	keepTarget = true
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.swipeAtk()

func _onExit() -> void:
	entity.stopAttack()
