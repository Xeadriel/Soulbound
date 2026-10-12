class_name EnemyNavigation extends NavigationRegion2D
## The navigation mesh enemies find their way on. Built at runtime: the map's area is
## walkable, minus everything solid (tile collision polygons and the static bodies of
## collidable world objects, see PropertyCollidable), just like for physics bodies.
## Rebakes itself when a world object starts or stops blocking, e.g. a door opening.
## Every map with enemies that should walk around walls needs one of these.

## Static bodies (and the TileMapLayer) in this group are carved out of the mesh.
const OBSTACLE_GROUP := &"navigationObstacles"

## The map's tiles. Defaults to the parent node.
@export var tileMapLayer: TileMapLayer
## How far paths stay away from walls and objects. Roughly the enemies' body radius:
## larger snags less on corners, smaller fits through tighter gaps.
@export var agentRadius := 48.0
## Changes within this many seconds are merged into a single rebake.
@export var rebakeDelay := 0.1

var _rebakeTimer := Timer.new()
var _isBaking := false
var _rebakeQueued := false

func _ready() -> void:
	if tileMapLayer == null:
		tileMapLayer = get_parent() as TileMapLayer
	assert(tileMapLayer != null, "EnemyNavigation needs a TileMapLayer")
	tileMapLayer.add_to_group(OBSTACLE_GROUP)
	navigation_polygon = _createNavigationPolygon()

	_rebakeTimer.one_shot = true
	_rebakeTimer.wait_time = rebakeDelay
	_rebakeTimer.timeout.connect(_rebake)
	add_child(_rebakeTimer)

	bake_finished.connect(_onBakeFinished)
	EventBus.navigationObstaclesChanged.connect(requestRebake)
	# the first bake also waits for the timer, so every world object is ready by then
	requestRebake()

## Rebakes the navigation mesh shortly. Requests that come in before then share the bake.
func requestRebake() -> void:
	if is_inside_tree() and _rebakeTimer.is_stopped():
		_rebakeTimer.start()

func _rebake() -> void:
	if _isBaking:
		_rebakeQueued = true
		return
	_isBaking = true
	bake_navigation_polygon(true)

func _onBakeFinished() -> void:
	_isBaking = false
	if _rebakeQueued:
		_rebakeQueued = false
		_rebake()

func _createNavigationPolygon() -> NavigationPolygon:
	var polygon := NavigationPolygon.new()
	polygon.agent_radius = agentRadius
	polygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	# wall tiles are on OBSTACLE, world objects' static bodies on PLAYER (see PhysicsLayers)
	polygon.parsed_collision_mask = PhysicsLayers.bit(PhysicsLayers.OBSTACLE) | PhysicsLayers.bit(PhysicsLayers.PLAYER)
	polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_EXPLICIT
	polygon.source_geometry_group_name = OBSTACLE_GROUP
	# not just the painted floor: doorways and some spots under world objects are left
	# unpainted. Outside the map's walls stays unreachable anyway.
	polygon.add_outline(_mapOutline())
	return polygon

## The area the map's tiles cover plus a one-tile border, in this node's coordinates.
func _mapOutline() -> PackedVector2Array:
	var halfTile := Vector2(tileMapLayer.tile_set.tile_size) / 2
	var cells := tileMapLayer.get_used_rect().grow(1)
	var topLeft := tileMapLayer.map_to_local(cells.position) - halfTile
	var bottomRight := tileMapLayer.map_to_local(cells.end - Vector2i.ONE) + halfTile
	var outline := PackedVector2Array()
	for corner: Vector2 in [topLeft, Vector2(bottomRight.x, topLeft.y), bottomRight, Vector2(topLeft.x, bottomRight.y)]:
		outline.append(to_local(tileMapLayer.to_global(corner)))
	return outline
