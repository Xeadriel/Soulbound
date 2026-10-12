class_name PropertyCollidable extends Area2D
## Makes a world object solid through its CollisionStaticBody. While enabled, the body
## also blocks enemy paths (see EnemyNavigation). Disabling this node or one of its
## parents (process_mode), e.g. to open a door, clears the way for enemies too.

@onready var staticBody: StaticBody2D = get_node_or_null("CollisionStaticBody")

func _ready() -> void:
	_setBlocksNavigation(can_process())

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENABLED:
			_setBlocksNavigation(true)
		NOTIFICATION_DISABLED:
			_setBlocksNavigation(false)
		NOTIFICATION_EXIT_TREE:
			# the object is removed, its body no longer blocks
			EventBus.navigationObstaclesChanged.emit()

func _setBlocksNavigation(blocks: bool) -> void:
	# notifications can come in before _ready, which then sets the initial state
	if staticBody == null or blocks == staticBody.is_in_group(EnemyNavigation.OBSTACLE_GROUP):
		return
	if blocks:
		staticBody.add_to_group(EnemyNavigation.OBSTACLE_GROUP)
	else:
		staticBody.remove_from_group(EnemyNavigation.OBSTACLE_GROUP)
	EventBus.navigationObstaclesChanged.emit()
