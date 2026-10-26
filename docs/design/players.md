# Players and combat

## Basics

**Status:** Decided

- Two players (local co-op). See [story.md](../story.md#the-player-characters) for who they are.
- Sword and shield.
- Block only via timing.
- Move in 8 directions, attack in 8 directions.

**Built:**
- Both players share the code in [Player.gd](../../Scripts/Players/Player.gd) and the scene `Scenes/Players/PlayerBase.tscn`. [Player1.gd](../../Scripts/Players/Player1.gd) is the sword fighter and [Player2.gd](../../Scripts/Players/Player2.gd) the mage. Both have 6 HP (3 hearts).
- Blocking is **held**, not timed (see [Blocking](#blocking) below).

## Attack combos

**Status:** Decided

- **Player 1** has two 3-hit combos:
  - light: slash, slash, stab
  - heavy, slow but with more range: stab, wide slash, wide slash
- **Player 2:**
  - light: pew pew pew, mini cooldown, pew pew pew …
  - heavy: charges as long as "pew pew pew + mini cooldown", then shoots 5 at once, then a mini break

**Built:**
- Player 1: `StateAttack` (light, 3 hits, 1 damage each) and `StateHeavyAttack` (3 hits with wind-up, 2 damage each).
- Player 2: `StateAttack` fires `MagicShot` projectiles (1 damage). `StateChargeUpAttack` charges in 3 levels while heavy is held and fires 1, 1, then 3 shots on release (`Player2.CHARGE_SPAWN_INDICES`).

## Blocking

**Status:** Decided (as built)

- Hold block to block in the facing direction. Facing is locked while blocking, attacks are disabled, and the player moves slowly. Dash, quick slots and interact still work.
- A hit is blocked when it comes from the direction the player faces.
- **Block redirect (player 2):** tapping hit while blocking moves player 2's block onto player 1, protecting player 1 from the direction player 2 faces. Player 2 is unprotected meanwhile. Tap again to take it back.

**Built:** [StateBlock.gd](../../Scripts/StateMachine/StatesPlayer/StateBlock.gd), [StateBlockRedirect.gd](../../Scripts/StateMachine/StatesPlayer/StateBlockRedirect.gd), `Player._blocksHitFrom()`.

## Combat mechanic idea: timed block

**Status:** Idea

When an attack would hit, give a generous window to press a button, which starts a tight quick-time action: 2–4 buttons to press in sequence quickly. Success: blocked. Fail: hit.

## Dash

**Status:** Decided (as built)

Short dash in the aiming direction with a cooldown. [StateDash.gd](../../Scripts/StateMachine/StatesPlayer/StateDash.gd).

## Friendly fire

**Status:** Open (needs playtesting)

Which of these should player 2's projectiles do to player 1?
1. No collision with the partner.
2. Collision but no damage.
3. Collision and damage.

## Attacks and the environment

**Status:** Idea

Make interesting environments so that every attack can have an impact (knockback effect) that interacts with the environment.

## Controls

**Status:** Built (keyboard only, both players on one keyboard). Defined in Project Settings > Input Map, wrapped per player by [PlayerInputProfile](../../Scripts/Input/PlayerInputProfile.gd).

| Action | Player 1 | Player 2 |
|---|---|---|
| Move | W A S D | I J K L |
| Attack (hit) | Space | Ctrl |
| Heavy attack | Alt | − (minus) |
| Block | Q | U |
| Dash | Shift | Shift (same key as player 1) |
| Interact | E | O |
| Quick slots (bottom, top, left, right) | 1 2 3 4 | 7 8 9 0 |
| Pause menu | Esc | F10 |
