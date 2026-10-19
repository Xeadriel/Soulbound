extends StateEnemyAnimated

func _init() -> void:
	animation = "telegraph"
	faceTarget = true
	nextState = ATK
