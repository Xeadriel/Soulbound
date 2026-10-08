class_name PlayerInputProfile extends Resource
## The input actions (from Project Settings > Input Map) that belong to one player.

@export var up: StringName = &"up"
@export var down: StringName = &"down"
@export var left: StringName = &"left"
@export var right: StringName = &"right"
@export var hit: StringName = &"hit"
@export var heavyHit: StringName = &"heavyHit"
@export var block: StringName = &"block"
@export var dash: StringName = &"dash"
@export var interact: StringName = &"interact"
@export var pause: StringName = &"pause"
## Indexed by GlobalConstants.QuickSlotIndices (BOTTOM, TOP, LEFT, RIGHT).
@export var quickSlots: Array[StringName] = [
	&"quickSlotBottom", &"quickSlotTop", &"quickSlotLeft", &"quickSlotRight"
]

const _PROFILE_PATH := "res://Resources/Input/Player%dInput.tres"

## The profile of the player with the given index (0 or 1).
static func forPlayer(playerIndex: int) -> PlayerInputProfile:
	return load(_PROFILE_PATH % (playerIndex + 1))

## Movement direction from the four direction actions. Not normalized, so diagonals
## are (±1, ±1), the same as before.
func moveVector() -> Vector2:
	return Vector2(Input.get_axis(left, right), Input.get_axis(up, down))
