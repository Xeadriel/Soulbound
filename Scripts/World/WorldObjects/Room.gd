class_name Room extends Node2D
## A room of the dungeon. Its PropertyDetectingPlayer children tell it when players come in.
## Enemies inside stay idle until the room wakes up, and visited rooms show up on the
## pause menu map. The room's name has to match its sprite in the menu map.

## The room wakes up. Enemies in the room start fighting.
signal awakened
## The first time both players are inside, e.g. to close the doors of a boss room.
signal bothPlayersEntered

## Wake only once both players are inside instead of when the first one walks in.
## For rooms like boss rooms, where the fight must not start with a player left outside.
@export var wakeWhenBothPlayersInside := false

var isAwake := false
var _bothPlayersWereIn := false

func _ready() -> void:
	for detector : PropertyDetectingPlayer in find_children("*", "PropertyDetectingPlayer", false):
		detector.player1Entered.connect(_onPlayerEntered)
		detector.player2Entered.connect(_onPlayerEntered)
		detector.bothPlayersAreNowIn.connect(_onBothPlayersIn)

## The room [param node] is in, or null when it's not in one.
static func containing(node: Node) -> Room:
	var parent := node.get_parent()
	while parent != null:
		if parent is Room:
			return parent
		parent = parent.get_parent()
	return null

## The rank-and-file enemies alive in this room: Goblins and Wizards, no bosses or
## elites. The miniboss sacrifices these, and EnemySpawner caps its spawns by them.
func minionEnemies() -> Array[Enemy]:
	var result : Array[Enemy] = []
	for child in get_children():
		if (child is Goblin or child is Wizard) and not child.is_queued_for_deletion():
			result.append(child)
	return result

func _onPlayerEntered() -> void:
	GlobalStates.session.markRoomVisited(name)
	if not wakeWhenBothPlayersInside:
		_wake()

func _onBothPlayersIn() -> void:
	if not _bothPlayersWereIn:
		_bothPlayersWereIn = true
		bothPlayersEntered.emit()
	_wake()

func _wake() -> void:
	if not isAwake:
		isAwake = true
		awakened.emit()
