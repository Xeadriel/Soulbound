class_name EnemySpawner extends Node2D
## Slowly repopulates its room with enemies, up to a cap. Spawn positions are its
## Marker2D children. Starts when the room wakes up; stop() ends it, e.g. from an
## EnemyCounter's enemiesCleared.
##
## The cap counts every minion alive in the room (Room.minionEnemies()), pre-placed
## ones included, so minions the miniboss sacrifices make room for new ones.

## Scenes to spawn, one picked at random per spawn.
@export var enemyScenes : Array[PackedScene] = []
## Most minions alive in the room at once. Nothing spawns while the room is at the cap.
@export var maxAlive := 4
## Wait before the first spawn once the room wakes up, in seconds.
@export var initialDelay := 8.0
## Wait between spawns in seconds, from an empty room (min) to one below the cap (max).
## An emptied room refills sooner than a nearly full one tops up.
@export var minInterval := 8.0
@export var maxInterval := 18.0
## Random amount added to or taken from every wait, so spawns don't feel like clockwork.
@export var intervalJitter := 3.0
## Spawn points closer than this to a player are skipped.
@export var minPlayerDistance := 250.0
## Spawn points closer than this to a minion are skipped.
@export var minEnemyDistance := 100.0
## How long the warning shows at the spawn point before the enemy appears. 0 disables it.
@export var warningTime := 0.75
## Blinks at the spawn point during the warning. Without one there is only the delay.
@export var warningTexture : Texture2D

## How often a full room (or one with no usable spawn point) is checked again, in seconds.
const RECHECK_INTERVAL := 1.0

var _room : Room
var _points : Array[Marker2D] = []
var _timer : Timer
var _running := false
## False while the room is full. When a slot frees up, the spawner first waits a
## whole interval, so killing a minion does not bring a new one a second later.
var _spawnDue := false
## Spawns whose warning is still showing. They count toward the cap.
var _pendingSpawns := 0

func _ready() -> void:
	assert(not enemyScenes.is_empty(), "EnemySpawner needs at least one enemy scene")
	for child in get_children():
		if child is Marker2D:
			_points.append(child)
	assert(not _points.is_empty(), "EnemySpawner needs Marker2D children as spawn points")

	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_onTimerTimeout)
	add_child(_timer)

	_room = Room.containing(self)
	assert(_room != null, "EnemySpawner has to be inside a Room")
	if _room.isAwake:
		start()
	else:
		_room.awakened.connect(start, CONNECT_ONE_SHOT)

func start() -> void:
	if _running:
		return
	_running = true
	_spawnDue = true
	_timer.start(initialDelay)

## Stops spawning. With [param killRemaining] the minions still alive in the room die too.
func stop(killRemaining := false) -> void:
	_running = false
	_timer.stop()
	if killRemaining:
		for enemy in _room.minionEnemies():
			enemy.takeDamage(9999)

func _aliveCount() -> int:
	return _room.minionEnemies().size() + _pendingSpawns

func _onTimerTimeout() -> void:
	if not _running:
		return
	if _aliveCount() >= maxAlive:
		_spawnDue = false
		_timer.start(RECHECK_INTERVAL)
		return
	if not _spawnDue:
		# a slot just freed up: wait an interval before filling it
		_spawnDue = true
		_timer.start(_nextInterval())
		return

	var point := _pickSpawnPoint()
	if point == null:
		_timer.start(RECHECK_INTERVAL)
		return
	_spawnAt(point.global_position)
	_timer.start(_nextInterval())

func _nextInterval() -> float:
	var fill := clampf(float(_aliveCount()) / maxAlive, 0.0, 1.0)
	var wait := lerpf(minInterval, maxInterval, fill) + randf_range(-intervalJitter, intervalJitter)
	return maxf(wait, RECHECK_INTERVAL)

## A random spawn point away from the players and the other minions, or null if there is none.
func _pickSpawnPoint() -> Marker2D:
	var players := get_tree().get_nodes_in_group("Players")
	var minions := _room.minionEnemies()
	var usable : Array[Marker2D] = []
	for point in _points:
		if _isNear(point.global_position, players, minPlayerDistance):
			continue
		if _isNear(point.global_position, minions, minEnemyDistance):
			continue
		usable.append(point)
	return usable.pick_random() if not usable.is_empty() else null

func _isNear(pos: Vector2, nodes: Array, distance: float) -> bool:
	for node : Node2D in nodes:
		if node.global_position.distance_to(pos) < distance:
			return true
	return false

func _spawnAt(pos: Vector2) -> void:
	if warningTime > 0:
		_pendingSpawns += 1
		var warning := _showWarning(pos)
		await get_tree().create_timer(warningTime, false).timeout
		_pendingSpawns -= 1
		if warning != null:
			warning.queue_free()
		if not _running:
			return

	var enemy : Enemy = enemyScenes.pick_random().instantiate()
	# set before adding, so the enemy is in place when its _ready runs
	enemy.position = _room.to_local(pos)
	# added to the room so it wakes right away and the miniboss can sacrifice it
	_room.add_child(enemy)

func _showWarning(pos: Vector2) -> Sprite2D:
	if warningTexture == null:
		return null
	var sprite := Sprite2D.new()
	sprite.texture = warningTexture
	add_child(sprite)
	sprite.global_position = pos
	var tween := sprite.create_tween().set_loops()
	tween.tween_property(sprite, "modulate:a", 0.2, 0.15)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.15)
	return sprite
