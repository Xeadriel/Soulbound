class_name AutoCamera extends Node2D
## Follows the midpoint between the players and walls them in at the edges of the
## visible area, so nobody can walk off screen. The walls are sized from the viewport,
## so they always match what is actually visible.

## How quickly the camera catches up with the players. Higher is snappier.
@export var FOLLOW_SPEED := 10.0
## Moves the walls inwards from the edges of the screen, in pixels.
@export var BORDER_MARGIN := 0.0

@onready var camera : Camera2D = $Camera2D
@onready var topBorder : CollisionShape2D = $CameraBorder/Top
@onready var bottomBorder : CollisionShape2D = $CameraBorder/Bottom
@onready var leftBorder : CollisionShape2D = $CameraBorder/Left
@onready var rightBorder : CollisionShape2D = $CameraBorder/Right

## Where the camera actually is; global_position is this rounded to whole pixels
## so the world doesn't shimmer while the camera eases towards the players.
var _followPosition : Vector2

func _ready() -> void:
	# start on the players, before the first physics step: the walls would shove anyone
	# outside of them back in, all the way across the map
	_followPosition = _playersCenter()
	global_position = _followPosition.round()
	get_viewport().size_changed.connect(updateBorders)
	updateBorders()

func _physics_process(delta: float) -> void:
	_followPosition = _followPosition.lerp(_playersCenter(), 1.0 - exp(-FOLLOW_SPEED * delta))
	global_position = _followPosition.round()

## Size of the world area the camera shows.
func visibleSize() -> Vector2:
	return get_viewport_rect().size / camera.zoom

## Puts the walls on the edges of the visible area. Call this after changing the zoom.
func updateBorders() -> void:
	var halfSize := visibleSize() / 2 - Vector2(BORDER_MARGIN, BORDER_MARGIN)
	topBorder.position = Vector2(0, -halfSize.y)
	bottomBorder.position = Vector2(0, halfSize.y)
	leftBorder.position = Vector2(-halfSize.x, 0)
	rightBorder.position = Vector2(halfSize.x, 0)

## Midpoint of all players, or where the camera already is when there are none.
func _playersCenter() -> Vector2:
	var sum := Vector2.ZERO
	var count := 0
	for player : Node2D in get_tree().get_nodes_in_group("Players"):
		if player.is_queued_for_deletion():
			continue
		sum += player.global_position
		count += 1
	if count == 0:
		return global_position
	return sum / count
