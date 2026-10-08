class_name SlippyBoxPushPuzzleBoxTogglable extends StaticBody2D
## Green or red puzzle block. Only one color is solid at a time; player 2 swaps them.

const INACTIVE_COLOR := Color(0.439, 0.439, 0.439)
const ACTIVE_COLOR := Color(1.0, 1.0, 1.0)

func isSolid() -> bool:
	return process_mode != Node.PROCESS_MODE_DISABLED

func toggle() -> void:
	if isSolid():
		process_mode = Node.PROCESS_MODE_DISABLED
		modulate = INACTIVE_COLOR
	else:
		process_mode = Node.PROCESS_MODE_INHERIT
		modulate = ACTIVE_COLOR
