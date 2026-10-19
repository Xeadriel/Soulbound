extends StateEnemyAnimated

func _init() -> void:
	animation = "daggerCircling"
	keepTarget = true
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.daggerCirclingAtk()
