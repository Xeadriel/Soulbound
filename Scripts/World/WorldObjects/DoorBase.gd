class_name DoorBase extends WorldObject
## Shared door behavior: wall orientation and opening/closing.
##
## Horizontal and vertical doors use different animations ("Open" vs
## "VerticalOpen"), because top-down sprites can't simply be rotated. Only the
## collider is rotated for vertical doors.

@export var isHorizontal = true

var CLOSE = "Close"
var OPEN = "Open"

@onready var propertyCollidable : PropertyCollidable = $PropertyCollidable

func _ready() -> void:
	if not isHorizontal:
		propertyCollidable.rotation_degrees = 90
		CLOSE = "VerticalClose"
		OPEN = "VerticalOpen"

	set_process(false)
	set_physics_process(false)

## Opens or closes the door. The collider is switched off while the door is open.
## [param animationName] overrides the animation to play (e.g. the already-open frame).
func setOpen(open : bool, animationName : String = "") -> void:
	propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED if open else Node.PROCESS_MODE_INHERIT
	if animationName.is_empty():
		animationName = OPEN if open else CLOSE
	play(animationName)
