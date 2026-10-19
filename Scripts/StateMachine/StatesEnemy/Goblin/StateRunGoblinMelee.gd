extends StateEnemy
## Runs along the navigation path towards the target until it is in attack range and
## can see it, then starts circling.

func process(_delta: float) -> void:
	var distance := targetClosestPlayer()
	if targetOutOfChaseRange():
		transition(IDLE)
	elif distance < entity.atkRange and canSeeTarget():
		transition(RUNCIRCLE)
	else:
		runTowardsTarget(entity.SPEED)
