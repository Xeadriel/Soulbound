class_name StateRunEliteWizard extends StateEnemy
## Telegraphs an attack once the target is in attack range and a fireball would reach it.
## Until then runs along the navigation path to a firing spot of its own around the
## target, so a group of wizards spreads out instead of queueing at the same wall corner.
## Used by the wizard and the elite wizard.

@export var SPEED : int
## Radius of the shot for the clear-shot check: the fireball's (11) plus a margin.
@export var shotRadius := 14.0
## Each wizard prefers to shoot from a random distance in this range, as a fraction of
## atkRange, so wizards don't all line up on the same circle around the target.
@export var minRangeFactor := 0.6
@export var maxRangeFactor := 0.9
## Firing spots closer than this to another enemy (or where it is heading) count as crowded.
@export var firingSpotSpacing := 160.0
## How much a fully crowded spot costs, as extra walking distance in px.
@export var crowdCost := 300.0
## Doesn't start shooting with another enemy closer than this, unless at its firing spot.
@export var personalSpace := 120.0
## Roughly how often a better firing spot is looked for, in seconds.
@export var repickInterval := 0.5
## A spot that is this much cheaper than the current one is worth switching to.
@export var switchMargin := 0.25

## Candidate spots per ring around the target. The inner ring is at INNER_RING of the
## preferred distance.
const SPOTS_PER_RING := 16
const INNER_RING := 0.7
## A candidate further than this from the navigation mesh is inside a wall or object.
const MAX_SNAP_DISTANCE := 32.0
## The firing spot counts as reached this close to it.
const ARRIVE_DISTANCE := 32.0
## Only this many of the closest candidates get their walking distance measured.
const WALK_CHECKS := 4
## The candidate check uses a slightly wider shot than shooting itself, so standing a bit
## off the spot (the separation push) still leaves a clear shot.
const CANDIDATE_SHOT_MARGIN := 8.0

var _rangeFactor := 1.0
var _repickTimer := 0.0
## A spot that turned out to have no clear shot once reached, skipped when picking.
var _rejectedSpot := Enemy.NO_SPOT
## Whether the last search found no firing spot, so the wizard shoots from wherever it can.
var _noSpotFound := false

func _ready() -> void:
	super._ready()
	_rangeFactor = randf_range(minRangeFactor, maxRangeFactor)

func enter(_previous_state_path: String, _data := {}) -> void:
	_repickTimer = 0.0
	_rejectedSpot = Enemy.NO_SPOT
	_noSpotFound = false

func exit() -> void:
	entity.firingSpot = Enemy.NO_SPOT

func process(delta: float) -> void:
	var distance := targetClosestPlayer()

	# not aggroed
	if targetOutOfChaseRange():
		transition(IDLE)
		return

	var canShoot := distance <= entity.atkRange \
			and entity.hasClearShot(entity.global_position, entity.target, shotRadius)
	# shoot from where it stands as long as it isn't crowding another enemy there
	if canShoot and not entity.isCrowded(personalSpace):
		transition(TELEGRAPH)
		return

	var reachedSpot := entity.firingSpot.is_finite() \
			and entity.global_position.distance_to(entity.firingSpot) <= ARRIVE_DISTANCE
	if reachedSpot and not canShoot:
		_rejectedSpot = entity.firingSpot
		entity.firingSpot = Enemy.NO_SPOT
	_repickTimer -= delta
	if _repickTimer <= 0.0 or (reachedSpot and not canShoot):
		_repickTimer = repickInterval * randf_range(0.8, 1.2)
		_pickFiringSpot()

	# crowded, but this is the best place there is
	var atSpot := entity.firingSpot.is_finite() \
			and entity.global_position.distance_to(entity.firingSpot) <= ARRIVE_DISTANCE
	if canShoot and (atSpot or _noSpotFound):
		transition(TELEGRAPH)
	elif entity.firingSpot.is_finite():
		runTo(entity.firingSpot, SPEED)
	else:
		# no spot to shoot from (or no navigation mesh): close in around walls
		runTowardsTarget(SPEED)

## Picks the cheapest spot to shoot the target from: a short walk away and away from
## other enemies and their spots. Keeps the current spot unless another one is clearly
## cheaper, so the wizard doesn't change its mind every pick.
func _pickFiringSpot() -> void:
	var current := entity.firingSpot
	var candidates := _candidateSpots()
	if current.is_finite() and _isValidSpot(current):
		candidates.append(current)
	if candidates.is_empty():
		entity.firingSpot = Enemy.NO_SPOT
		_noSpotFound = true
		return
	_noSpotFound = false

	# cheap estimate first, then the real walk for the most promising ones
	var estimates := {}
	for spot: Vector2 in candidates:
		estimates[spot] = entity.global_position.distance_to(spot) + _crowdCost(spot)
	candidates.sort_custom(func(a: Vector2, b: Vector2) -> bool: return estimates[a] < estimates[b])

	var best := Enemy.NO_SPOT
	var bestCost := INF
	var currentCost := INF
	var checked := 0
	for spot: Vector2 in candidates:
		if checked >= WALK_CHECKS and spot != current:
			continue
		var walk := entity.walkingDistanceToPoint(spot)
		if walk == INF:
			continue
		checked += 1
		var cost := walk + _crowdCost(spot)
		if spot == current:
			currentCost = cost
		if cost < bestCost:
			bestCost = cost
			best = spot
	if currentCost < INF and bestCost > currentCost * (1.0 - switchMargin):
		best = current
	entity.firingSpot = best
	_noSpotFound = not best.is_finite()

## Spots on two rings around the target, on the navigation mesh, with a clear shot.
func _candidateSpots() -> Array[Vector2]:
	var spots: Array[Vector2] = []
	var center := entity.target.global_position
	var preferredRange := entity.atkRange * _rangeFactor
	for ring in 2:
		var radius := preferredRange * (INNER_RING if ring == 1 else 1.0)
		# the inner ring sits between the outer ring's angles
		var angleOffset := PI / SPOTS_PER_RING * ring
		for i in SPOTS_PER_RING:
			var sample := center + Vector2.RIGHT.rotated(TAU * i / SPOTS_PER_RING + angleOffset) * radius
			var spot := entity.closestNavigationPoint(sample)
			if not spot.is_finite() or spot.distance_to(sample) > MAX_SNAP_DISTANCE:
				continue
			if _rejectedSpot.is_finite() and spot.distance_to(_rejectedSpot) < ARRIVE_DISTANCE * 2:
				continue
			if _isValidSpot(spot):
				spots.append(spot)
	return spots

## Whether the target is in attack range from [param spot] and a shot would reach it.
func _isValidSpot(spot: Vector2) -> bool:
	return spot.distance_to(entity.target.global_position) <= entity.atkRange \
			and entity.hasClearShot(spot, entity.target, shotRadius + CANDIDATE_SHOT_MARGIN)

func _crowdCost(spot: Vector2) -> float:
	return entity.crowding(spot, firingSpotSpacing) * crowdCost
