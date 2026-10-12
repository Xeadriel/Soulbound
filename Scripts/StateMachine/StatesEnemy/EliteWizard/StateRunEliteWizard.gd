class_name StateRunEliteWizard extends StateEnemy
## Runs along the navigation path towards the target until it is in attack range and
## can see it, then telegraphs an attack. Used by the wizard and the elite wizard.

@export var SPEED : int

func process(_delta: float) -> void:
	var distance := targetClosestPlayer()

	# not aggroed
	if targetOutOfChaseRange():
		transition(IDLE)
	# attacking when in range and nothing is in the way
	elif distance <= entity.atkRange and canSeeTarget():
		transition(TELEGRAPH)
	# close distance to attack, around walls
	else:
		runTowardsTarget(SPEED)
