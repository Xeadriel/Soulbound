extends Node
## Buffers gameplay button presses so they can be read a little after they happen.
##
## Presses are recorded the moment their input event arrives. States then poll
## consumePress() during their own tick. A press counts once (the first reader
## consumes it) and only while it is younger than the buffer window, so pressing
## attack just before the current attack ends still chains the combo, but a press
## nobody reads expires instead of firing much later.

## How long a press stays usable if nothing consumes it, in milliseconds.
const DEFAULT_BUFFER_MS := 200

const _NO_PRESS := -1

var _actions: Array[StringName] = []
var _pressedAt: Dictionary[StringName, int] = {}
var _held: Dictionary[StringName, bool] = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for action in InputMap.get_actions():
		if String(action).begins_with("ui_"):
			continue
		_actions.append(action)
		_pressedAt[action] = _NO_PRESS
		_held[action] = false

func _unhandled_input(event: InputEvent) -> void:
	# no early exit: one key can be bound to several actions (e.g. a menu and a gameplay action)
	for action in _actions:
		if event.is_action_pressed(action):
			_pressedAt[action] = Time.get_ticks_msec()
			_held[action] = true
		elif event.is_action_released(action):
			_held[action] = false

## Returns true once per press if the press is younger than [param bufferMs].
## Reading it consumes the press, so later readers get false.
func consumePress(action: StringName, bufferMs: int = DEFAULT_BUFFER_MS) -> bool:
	var pressedAt: int = _pressedAt.get(action, _NO_PRESS)
	if pressedAt == _NO_PRESS:
		return false
	_pressedAt[action] = _NO_PRESS
	return Time.get_ticks_msec() - pressedAt <= bufferMs

## True while the button is held down. Does not consume anything.
func isHeld(action: StringName) -> bool:
	return _held.get(action, false)
