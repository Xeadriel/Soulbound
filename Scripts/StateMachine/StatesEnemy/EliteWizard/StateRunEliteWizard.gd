class_name StateRunEliteWizard extends StateEnemy
## Runs towards the target until it is in attack range, then telegraphs an attack.
## Used by the wizard and the elite wizard.

@export var SPEED : int

func process(_delta: float) -> void:
	var distance := targetClosestPlayer()

	# not aggroed
	if entity.aggroRange < distance:
		transition(IDLE)
	# close distance to attack
	elif entity.atkRange < distance:
		var direction := directionToTarget()
		entity.velocity = direction * SPEED
		entity.facing = Facing.fromVector(direction)
		entity.run()
	# attacking when in range
	elif entity.atkRange >= distance:
		transition(TELEGRAPH)
