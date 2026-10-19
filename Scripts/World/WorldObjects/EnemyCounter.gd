class_name EnemyCounter extends Node2D
## Emits enemiesCleared once every tracked enemy has died. Enemies are listed in
## trackedEnemies, or added at runtime with track().

signal enemiesCleared

@export var trackedEnemies : Array[Enemy] = []

var enemiesLeft := 0
var _cleared := false

func _ready() -> void:
	for enemy in trackedEnemies:
		track(enemy)

## Counts [param enemy] until it dies.
func track(enemy: Enemy) -> void:
	enemiesLeft += 1
	# one shot: died can fire again if the enemy takes damage before it is freed
	enemy.died.connect(_onTrackedEnemyDied, CONNECT_ONE_SHOT)

func _onTrackedEnemyDied() -> void:
	enemiesLeft -= 1
	if enemiesLeft <= 0 and not _cleared:
		_cleared = true
		enemiesCleared.emit()
