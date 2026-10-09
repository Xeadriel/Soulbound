class_name PhysicsLayers
## Readable names for the 2D physics layers set up in Project Settings > Layer Names.
## The values are layer numbers (1-32), as used by set_collision_layer_value() and
## set_collision_mask_value(). Use bit() to turn one into a bitmask.

## The player's body. Enemies, the other player, enemy attacks and projectiles
## collide with this. Turned off while dashing, which makes the player untouchable.
## Note: world objects (doors, chests, ...) currently also sit on this layer.
const PLAYER := 1
const ENEMY := 2
const CAMERA_BORDER := 3
const OBSTACLE := 4
const WHIP := 5
## The player being somewhere. Triggers (rooms, floor buttons, interactables)
## detect this layer. It stays on while dashing, so triggers don't lose the player.
const PLAYER_PRESENCE := 8
## The slippy box push puzzle's own layer, so it never interacts with the world.
const PUZZLE := 20

static func bit(layer: int) -> int:
	return 1 << (layer - 1)

## Makes an area detect players through PLAYER_PRESENCE instead of PLAYER.
static func detectPlayerPresence(area: Area2D) -> void:
	area.set_collision_mask_value(PLAYER, false)
	area.set_collision_mask_value(PLAYER_PRESENCE, true)
