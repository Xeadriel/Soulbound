class_name PhysicsLayers
## Readable names for the 2D physics layers set up in Project Settings > Layer Names.
## The values are layer numbers (1-32), as used by set_collision_layer_value() and
## set_collision_mask_value(). Use bit() to turn one into a bitmask.

## The player's presence. Triggers such as rooms, floor buttons and interactables detect it.
const PLAYER := 1
const ENEMY := 2
const CAMERA_BORDER := 3
const OBSTACLE := 4
const WHIP := 5
## What enemy attacks and projectiles hit. Turned off while dodging.
const PLAYER_HITTABLE := 6
## What enemy and player bodies physically collide with. Turned off while dodging,
## so others can pass through a dashing player.
const PLAYER_BODY := 7
## The slippy box push puzzle's own layer, so it never interacts with the world.
const PUZZLE := 20

static func bit(layer: int) -> int:
	return 1 << (layer - 1)
