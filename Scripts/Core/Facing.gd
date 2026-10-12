class_name Facing
## The four directions a character can face, plus the rules for picking one.
##
## There are three rules on purpose. Players, blocking and enemies each pick a
## direction slightly differently, and merging them would change how the game feels.

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

## Animation name suffix for each direction, e.g. "idle" + "Front".
const ANIM_SUFFIX: Dictionary[Direction, String] = {
	Direction.UP: "Back",
	Direction.DOWN: "Front",
	Direction.LEFT: "Left",
	Direction.RIGHT: "Right",
}

## Player movement rule: y picks UP/DOWN, then x overrides it (horizontal wins on
## diagonals). Axes that are zero keep [param current].
static func fromInput(dir: Vector2, current: Direction) -> Direction:
	var result := current
	if dir.y < 0:
		result = Direction.UP
	elif dir.y > 0:
		result = Direction.DOWN

	if dir.x < 0:
		result = Direction.LEFT
	elif dir.x > 0:
		result = Direction.RIGHT
	return result

## Dominant axis rule, used to tell which side a hit came from.
## Ties go to the vertical axis.
static func fromDominantAxis(dir: Vector2) -> Direction:
	if abs(dir.x) > abs(dir.y):
		return Direction.LEFT if dir.x < 0 else Direction.RIGHT
	return Direction.UP if dir.y < 0 else Direction.DOWN

## Enemy rule: 90 degree quadrants centered on each direction.
static func fromAngleDeg(angle: float) -> Direction:
	if angle > -45 and angle <= 45:
		return Direction.RIGHT
	elif angle > 135 or angle <= -135:
		return Direction.LEFT
	elif angle < -45 and angle >= -135:
		return Direction.UP
	else:
		return Direction.DOWN

static func fromVector(dir: Vector2) -> Direction:
	return fromAngleDeg(rad_to_deg(dir.angle()))

## Rotation in radians that points along [param dir] (RIGHT is 0, DOWN is PI/2).
static func toAngle(dir: Direction) -> float:
	match dir:
		Direction.UP:
			return -PI / 2
		Direction.DOWN:
			return PI / 2
		Direction.LEFT:
			return PI
	return 0.0
