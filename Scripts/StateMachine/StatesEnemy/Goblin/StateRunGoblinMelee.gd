extends StateEnemy
## Runs towards the target until it is in attack range, then starts circling.

func process(_delta: float) -> void:
	var distance := targetClosestPlayer()
	if entity.aggroRange < distance:
		transition(IDLE)
	elif entity.atkRange <= distance:
		var direction := directionToTarget()
		entity.velocity = direction * entity.SPEED
		entity.facing = Facing.fromVector(direction)
		entity.run()
	else:
		transition(RUNCIRCLE)
