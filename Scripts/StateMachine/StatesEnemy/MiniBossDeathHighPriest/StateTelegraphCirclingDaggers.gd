extends StateTelegraphSacrifice
## Spawns daggers one after another on an evenly spaced circle around the target
## while the telegraph plays. When the sacrificed minion dies,
## StateAtkCirclingDaggers launches them.
##
## The state does the spawning itself instead of a coroutine, so it stops when the
## state ends and never waits on a dagger that may be gone.

const DAGGER_COUNT := 5
## Orbit speed in radians per second for a 1 second telegraph. Longer telegraphs
## orbit slower.
const ORBIT_SPEED := 10.0
## Spawning never takes more than this part of the telegraph, so the full circle is
## always there before the attack.
const MAX_SPAWN_PART := 0.5

const SPACING := TAU / DAGGER_COUNT

var _angularSpeed := 0.0
var _spawnInterval := 0.0
var _elapsed := 0.0
var _spawned := 0

func _init() -> void:
	animation = "telegraphDaggerCircling"
	faceTarget = true
	nextState = DAGGER_CIRCLING

func _onEnter(_data: Dictionary) -> void:
	var telegraphLength := duration
	if telegraphLength <= 0:
		telegraphLength = entity.animationLength(entity.animatedSprite.animation)
	_angularSpeed = ORBIT_SPEED / telegraphLength
	# normally a new dagger appears once the circle turned one spacing, so they all
	# appear at the same spot. If that is too slow they come faster and are placed
	# at their slot directly.
	_spawnInterval = minf(SPACING / _angularSpeed, telegraphLength * MAX_SPAWN_PART / (DAGGER_COUNT - 1))
	_elapsed = 0.0
	_spawned = 0
	_spawnDue()

func physicsProcess(delta: float) -> void:
	super.physicsProcess(delta)
	if not isActive:
		return
	_elapsed += delta
	_spawnDue()

func _onCancelled() -> void:
	entity.clearCirclingDaggers()

func _spawnDue() -> void:
	while _spawned < DAGGER_COUNT and _elapsed >= _spawned * _spawnInterval:
		# the first dagger starts at angle 0 and turns with the state's clock, so each
		# new one goes one spacing behind where the first one is now
		entity.spawnCirclingDagger(_angularSpeed * _elapsed - _spawned * SPACING, _angularSpeed)
		_spawned += 1

func getInterrupted(newState : String) -> void:
	_onCancelled()
