class_name EnemyCounter extends WorldObject

@export var enemiesLeft = 0

signal enemiesCleared

func onEnemyDied():
	enemiesLeft -= 1
	enemiesLeft = clamp(enemiesLeft, 0, INF)
	
	if enemiesLeft == 0:
		enemiesCleared.emit()
