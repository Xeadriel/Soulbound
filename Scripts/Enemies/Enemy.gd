class_name Enemy extends Character

@export var atkRange := 100.0
## Starts chasing a player who is closer than this, measured along the walking path.
@export var aggroRange:= 500.0
## Stops chasing once the player is this many times aggroRange away (walking), so an
## enemy taking a detour around a wall doesn't give up halfway.
@export var giveUpFactor := 1.25
@export var telegraphTime := 1.0
@export var atkTime := 1.0
## How often paths and walking distances to the players are recalculated, in seconds.
@export var repathInterval := 0.25
## Enemies that don't collide with other enemies (no ENEMY in their collision mask, so they
## can't jam doorways) push away from enemies closer than this instead. The body is 88 px wide.
@export var separationRadius := 100.0
## How fast that push moves the enemy at most, in px/s. Below the run speed, so an enemy
## still squeezes past another one standing in a doorway.
@export var separationSpeed := 60.0

## A path that ends further than this from a player means there is no way to them.
const REACHABLE_TOLERANCE := 64.0
## All enemies, so they can keep their distance from each other.
const GROUP := &"Enemies"
## No spot, e.g. no firingSpot picked.
const NO_SPOT := Vector2.INF
## What blocks sight and projectiles: wall tiles are on OBSTACLE, world objects' static
## bodies on PLAYER (see PhysicsLayers).
const _SIGHT_MASK := (1 << (PhysicsLayers.OBSTACLE - 1)) | (1 << (PhysicsLayers.PLAYER - 1))

var players
var target: Player
## Where this enemy is on its way to attack from, so others pick different spots instead
## of all crowding the same one. NO_SPOT when it isn't heading anywhere in particular.
var firingSpot := NO_SPOT

## Melee hitboxes, only present on enemies with melee attacks.
@onready var meleeHitboxes : DirectionalHitboxes = get_node_or_null("MeleeHitboxes")
## Finds paths on the map's navigation mesh (see EnemyNavigation). Enemies without
## one run straight at their target.
@onready var navAgent: NavigationAgent2D = get_node_or_null("NavigationAgent2D")

var _nextRepathTime := 0.0
var _walkingDistances: Dictionary[Player, float] = {}
var _walkingDistancesExpireTime := 0.0
var _isAwake := true

@export var DAMAGE = 1

func _ready() -> void:
	hp = maxHp
	add_to_group(GROUP)
	players = get_tree().get_nodes_in_group("Players")
	# until our room wakes up we only idle: body, hitbox and idle animation stay live,
	# but the state machine (aggro, attacks) doesn't start
	var room := Room.containing(self)
	if room != null and not room.isAwake:
		_isAwake = false
		stateMachine.startOnReady = false
		idle()
		room.awakened.connect(wake, CONNECT_ONE_SHOT)

## Lets the enemy start fighting.
func wake() -> void:
	_isAwake = true
	stateMachine.start()

func _physics_process(delta: float) -> void:
	if not _isAwake or get_collision_mask_value(PhysicsLayers.ENEMY):
		super._physics_process(delta)
		return
	# push away from nearby enemies in every state, also while telegraphing or attacking.
	# Only for this move: the states keep control of velocity.
	var stateVelocity := velocity
	velocity += separationDirection() * separationSpeed
	super._physics_process(delta)
	velocity = stateVelocity

func _onHpChanged() -> void:
	if hp < 1:
		died.emit()
		queue_free()

func takeDamage(amount: int, _source: Node2D = null) -> void:
	hp -= amount

## Called when an item hitbox (see ItemHitbox) hits this enemy.
func onItemHit(item: GlobalConstants.ItemIndices, _playerIndex: int) -> void:
	match item:
		GlobalConstants.ItemIndices.WHIP:
			stateMachine.interrupt(StateEnemy.STUNNED, {"duration" : 1.0})

func getDirectionToPlayer() -> Facing.Direction:
	return Facing.fromVector(global_position.direction_to(target.global_position))

## The player with the shortest walk to, so a player behind a wall doesn't win over
## one that can be reached.
func getClosestPlayer() -> Player:
	var closestPlayer: Player
	var closestDistance = INF
	for p in players:
		var distanceToPlayer = walkingDistanceTo(p)
		if closestPlayer == null or distanceToPlayer < closestDistance:
			closestDistance = distanceToPlayer
			closestPlayer = p
	return closestPlayer

# --- navigation ---

## Direction to run in to reach [param targetPosition] around walls and world objects.
## ZERO when there is nowhere closer to go on the navigation mesh.
func pathDirectionTo(targetPosition: Vector2) -> Vector2:
	if not _hasNavigation():
		return global_position.direction_to(targetPosition)
	var now := _now()
	var targetMoved := navAgent.target_position.distance_to(targetPosition) > navAgent.target_desired_distance
	if now >= _nextRepathTime or (navAgent.is_navigation_finished() and targetMoved):
		_nextRepathTime = now + repathInterval
		navAgent.target_position = targetPosition
	var nextPosition := navAgent.get_next_path_position()
	if navAgent.get_current_navigation_path().is_empty():
		# no navigation mesh here (yet)
		return global_position.direction_to(targetPosition)
	if navAgent.is_navigation_finished():
		return Vector2.ZERO
	return global_position.direction_to(nextPosition)

## How far this enemy has to walk to reach [param player], INF when there is no way to
## them. Straight-line distance for enemies without navigation, or before the
## navigation mesh is ready.
func walkingDistanceTo(player: Player) -> float:
	if not _hasNavigation():
		return global_position.distance_to(player.global_position)
	var now := _now()
	if now >= _walkingDistancesExpireTime:
		_walkingDistances.clear()
		_walkingDistancesExpireTime = now + repathInterval
	if not _walkingDistances.has(player):
		_walkingDistances[player] = _measureWalkingDistance(player.global_position)
	return _walkingDistances[player]

## Whether nothing solid (wall, world object) is between this enemy and [param node].
## Players and other enemies don't block the view.
func hasLineOfSightTo(node: Node2D) -> bool:
	var query := PhysicsRayQueryParameters2D.create(global_position, node.global_position, _SIGHT_MASK)
	query.exclude = _sightExcludes()
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

## Whether a projectile [param radius] wide flying from [param from] to [param node] gets
## there without touching anything solid. Stricter than hasLineOfSightTo: a thin line of
## sight past a wall corner can still be blocked for a projectile, and a start that
## already touches a wall counts as blocked. Players and other enemies don't block it.
func hasClearShot(from: Vector2, node: Node2D, radius: float) -> bool:
	var shape := CircleShape2D.new()
	shape.radius = radius
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, from)
	query.motion = node.global_position - from
	query.collision_mask = _SIGHT_MASK
	query.exclude = _sightExcludes()
	# [1, 1] when nothing is hit on the way, [0, 0] when the start is already blocked
	return get_world_2d().direct_space_state.cast_motion(query)[0] >= 1.0

## How crowded [param at] is by other enemies: each one closer than [param radius] to
## it, or heading for a firingSpot that close, adds up to 1, more the closer it is.
func crowding(at: Vector2, radius: float) -> float:
	var total := 0.0
	for other: Enemy in get_tree().get_nodes_in_group(GROUP):
		if other == self:
			continue
		var distance := at.distance_to(other.global_position)
		if other.firingSpot.is_finite():
			distance = minf(distance, at.distance_to(other.firingSpot))
		if distance < radius:
			total += 1.0 - distance / radius
	return total

## Whether another enemy stands closer than [param radius] to this one.
func isCrowded(radius: float) -> bool:
	for other: Node2D in get_tree().get_nodes_in_group(GROUP):
		if other != self and global_position.distance_squared_to(other.global_position) < radius * radius:
			return true
	return false

## Direction away from nearby enemies, stronger the closer they are. Length 0 to 1.
func separationDirection() -> Vector2:
	var push := Vector2.ZERO
	for other: Node2D in get_tree().get_nodes_in_group(GROUP):
		var offset := global_position - other.global_position
		if other == self or offset.length_squared() >= separationRadius * separationRadius:
			continue
		var distance := offset.length()
		if distance < 1.0:
			# exactly on top of each other: each enemy splits off in its own direction
			push += Vector2.RIGHT.rotated(deg_to_rad(get_instance_id() % 360))
		else:
			push += offset / distance * (1.0 - distance / separationRadius)
	return push.limit_length(1.0)

## The point on the navigation mesh closest to [param point], NO_SPOT when there is no
## navigation mesh (yet).
func closestNavigationPoint(point: Vector2) -> Vector2:
	if not _hasNavigation():
		return NO_SPOT
	return NavigationServer2D.map_get_closest_point(navAgent.get_navigation_map(), point)

## How far this enemy has to walk to reach [param point], INF when there is no way there.
func walkingDistanceToPoint(point: Vector2) -> float:
	if not _hasNavigation():
		return global_position.distance_to(point)
	return _measureWalkingDistance(point)

func _sightExcludes() -> Array[RID]:
	var excluded: Array[RID] = [get_rid()]
	for p in players:
		excluded.append(p.get_rid())
	return excluded

func _measureWalkingDistance(to: Vector2) -> float:
	var path := NavigationServer2D.map_get_path(navAgent.get_navigation_map(), global_position, to, true)
	if path.is_empty():
		# no navigation mesh here (yet)
		return global_position.distance_to(to)
	if path[-1].distance_to(to) > REACHABLE_TOLERANCE:
		return INF
	var length := 0.0
	for i in range(1, path.size()):
		length += path[i - 1].distance_to(path[i])
	return length

func _hasNavigation() -> bool:
	return navAgent != null and NavigationServer2D.map_get_iteration_id(navAgent.get_navigation_map()) > 0

func _now() -> float:
	return Time.get_ticks_msec() / 1000.0

# --- animations ---

func idle():
	playDirectional("idle")

func stunned():
	playDirectional("stunned")

func run():
	playDirectional("run")

func stopAttack() -> void:
	if meleeHitboxes != null:
		meleeHitboxes.disableAll()

func telegraphAttack() -> void:
	playDirectional("telegraph")

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE, self)
