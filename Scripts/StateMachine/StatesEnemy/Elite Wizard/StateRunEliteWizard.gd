class_name StateRunEliteWizard extends StateEnemy

@export var SPEED : int

func process(_delta: float) -> void:
	entity.target = entity.getClosestPlayer()
	var distance = entity.global_position.distance_to(entity.target.global_position)
	
	# not aggroed
	if  entity.aggroRange < distance:
		finished.emit(IDLE)
	# close distance to attack
	elif entity.atkRange < distance:
		var direction = entity.global_position.direction_to(entity.target.global_position)
		entity.velocity = direction.normalized() * SPEED
		entity.direction = entity.getDirectionFromVector(direction)
		entity.run()
	# attacking when in range
	elif entity.atkRange >= distance:
		finished.emit(TELEGRAPH)

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass
