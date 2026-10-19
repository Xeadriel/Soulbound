extends StateEnemyAnimated

func _init() -> void:
	animation = "daggerCone"
	keepTarget = true
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.daggerConeAtk()
