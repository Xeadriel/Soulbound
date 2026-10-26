# Items

How items are stored and shown (inventory, quick slots) is in [ui.md](ui.md).

## Chalice of death

**Status:** Idea (core to the story; see [story.md](../story.md#the-blood-chalice-and-the-death-god))

- Enemies come back as one big dungeon monster at the end of each dungeon run (see the end boss draft in [bosses.md](bosses.md#end-boss-dungeon-1)).
- The players choose whether to **kill the boss using the chalice**, soaking up the blood of the minions (unlocking a new optional ability?). This leads toward a "bad ending" that revives the god of death.
- Or they choose to **entrap the monster** instead: no extra reward and a few scripted monster outbreaks, but ultimately a good ending where he is not revived.
- Alternative: helping or not helping only makes him stronger or weaker, he revives either way at the end, and the players simply side for or against him.
- The chalice revives the players by sending them to the underworld, which they fight their way out of. Show this in the tutorial by having the players die.

## Whip (dungeon 1 item)

**Status:** Decided

- The first jungle item. Later upgraded to a grappling hook.
- Can pull things and stun enemies, and activate buttons and levers from afar.

**Built:**
- Found in the chest that appears after the miniboss.
- `StateWhipAttack` uses it from a quick slot.
- Enemies hit by it are stunned for 1 s (`Enemy.onItemHit`).
- World objects react through `PropertyWhippable` (e.g. levers).
- Definition: `Resources/Items/Whip.tres`.

## Bottle and potions

**Status:** Decided

- The **bottle** is a key item that is never used up. It holds one fluid at a time. The healing **potion** is the first fluid; other fluids (e.g. water) come later as new contents, not new items.
- Bottles are shared like the rest of the inventory: with one full bottle, whichever player drinks first gets it.
- **Drinking a potion** heals the drinker fully. The player stands still for a short moment (about 0.8 s) and can be hit meanwhile. It does nothing at full HP. Only the drinker is healed.
- The players start with one bottle of potion.
- **Refill spot:** a healing spring fills all empty bottles and never runs dry. One stands in MiniBossHallway, before the miniboss.

**Built** on branch `feature/drinkable-potions` (not merged yet):
- `GameSession.bottles`, `StateUseBottle` and the `HealingSpring` world object.
- Needed later: a drinking animation and bottle icons per content.

## Dungeon keys and money

**Status:** Decided (as built)

- **Small key:** opens one locked door in its dungeon and is used up (`Door.key`).
- **Pieces of eight:** money. Nothing to spend it on yet.

## Dash item

**Status:** Idea

An item for dashing (see also "wind boots" below). Dashing currently exists as a basic move for both players.

## Item idea pool

**Status:** Idea

- blow air
- boomerang
- bombs
- beyblade
- bow (magic arrows?)
- grappling hook
- 1 spell (fire, teleport, ice …?)
- fire blower
- **Echo Bell:** emits a sonar pulse. Reveals hidden platforms, invisible enemies or mimics. Can stun or disorient enemies.
- **Magnet Gauntlet:** pull metal objects or enemies toward you (or push them away).
- **Time Lens:** temporarily reveals past versions of a room (hidden doors, platforms, chests).
- **wind boots:** dash
- **slow boots:** allow stealth past enemies that can only see fast movements; slower, precise movement
- **spirit lantern:** scare, burn plants, make illusions visible

Also from the code (`GlobalConstants.ItemIndices.NOTHING`): spots where the players find "nothing", which is actually an item tracked by an achievement.
