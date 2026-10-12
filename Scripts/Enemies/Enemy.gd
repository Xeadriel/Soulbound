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

## A path that ends further than this from a player means there is no way to them.
const REACHABLE_TOLERANCE := 64.0

var players
var target: Player

## Melee hitboxes, only present on enemies with melee attacks.
@onready var meleeHitboxes : DirectionalHitboxes = get_node_or_null("MeleeHitboxes")
## Finds paths on the map's navigation mesh (see EnemyNavigation). Enemies without
## one run straight at their target.
@onready var navAgent: NavigationAgent2D = get_node_or_null("NavigationAgent2D")

var _nextRepathTime := 0.0
var _walkingDistances: Dictionary[Player, float] = {}
var _walkingDistancesExpireTime := 0.0

@export var DAMAGE = 1

func _ready() -> void:
	hp = maxHp
	players = get_tree().get_nodes_in_group("Players")
	# until our room wakes up we only idle: body, hitbox and idle animation stay live,
	# but the state machine (aggro, attacks) doesn't start
	var room := Room.containing(self)
	if room != null and not room.isAwake:
		stateMachine.startOnReady = false
		idle()
		room.awakened.connect(wake, CONNECT_ONE_SHOT)

## Lets the enemy start fighting.
func wake() -> void:
	stateMachine.start()

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
	# wall tiles are on OBSTACLE, world objects' static bodies on PLAYER (see PhysicsLayers)
	var query := PhysicsRayQueryParameters2D.create(global_position, node.global_position,
			PhysicsLayers.bit(PhysicsLayers.OBSTACLE) | PhysicsLayers.bit(PhysicsLayers.PLAYER))
	var excluded: Array[RID] = [get_rid()]
	for p in players:
		excluded.append(p.get_rid())
	query.exclude = excluded
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

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
