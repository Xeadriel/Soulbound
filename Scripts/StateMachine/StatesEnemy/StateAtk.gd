extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "attack"
	nextState = IDLE

func _onEnter(_data: Dictionary) -> void:
	entity.attack()

func _onExit() -> void:
	entity.stopAttack()
