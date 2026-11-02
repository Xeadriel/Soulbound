# Soulbound

Local two-player co-op, top-down action adventure in the style of 2D Zelda. Godot 4.4 (GL Compatibility renderer), GDScript only. Made by Xeadriel and Mono-Kaze; repo `github.com/Xeadriel/Soulbound`, main branch `master`.

## Docs

Design and story live in `docs/` as Markdown. Start at [docs/README.md](docs/README.md).

- **Before design work** (enemies, bosses, items, story, dungeons), read the matching file in `docs/`. Build on what is written there before inventing new ideas, and say which parts are new.
- **Respect the status tags:** Decided, Draft, Idea, Open. Don't treat a Draft or Idea as settled.
- **When a decision changes**, update the doc in the same branch as the code. Move answered questions out of `docs/open-questions.md`.
- `docs/` has a `.gdignore`, so Godot doesn't import its images.

## Running and checking

- **Godot console binary.** The path differs per machine. On Mono-Kaze's machine it is `F:\ExperimentGodot\Godot_v4.3-stable_win64.exe\Godot_v4.4-stable_win64_console.exe`. `Godot_v4.3-stable_win64.exe` is a folder, not the binary.
- **Import / generate `.uid` files for new scripts:** `<godot> --headless --path . --import`
- **Smoke test** the main scene `Scenes/World/Maps/DraftJungleDungeon.tscn`: `<godot> --headless --path . res://Scenes/World/Maps/DraftJungleDungeon.tscn --quit-after 300`, then check the output for `SCRIPT ERROR`.
- **Behavior tests:** write a throwaway scene and script in a temporary folder inside the project (it must be under `res://`, e.g. `_tmp_test/`), run it headless, and delete the folder afterwards.
  - Wait ~2 s after loading the map, because the navigation mesh bakes asynchronously.
  - When teleporting players, also move the `AutoCamera`. Its border walls push players back.
- **Known noise, not caused by your change:**
  - `progress_dialog` / `tasks.has` errors in headless editor runs.
  - A parse error for a stale `daggerCone.gd` in the `.godot` cache.
- `--check-only` on a single script fails on autoloads (`EventBus` etc.), so use a scene run instead.

## Architecture

- **Autoloads:**
  - `GlobalStates`: holds `session: GameSession`, the inventory, quick slots and map progress.
  - `EventBus`: global signals.
  - `InputBuffer`: buffered presses, read with `consumePress` / `isHeld`.
  - `GlobalConstants`: enums such as `ItemIndices`.
  - `GlobalScope`.
- **Characters:** `Character` → `Player` (`Player1` sword, `Player2` mage) and `Enemy` (`Goblin`, `Wizard`, `EliteWizard`, `MiniBossDeathHighPriest`). Each has a `StateMachine` with `State` children, in `Scripts/StateMachine/StatesPlayer` and `StatesEnemy`.
- **States:**
  - Switch with `transition(name)`. Outside code forces a switch with `stateMachine.interrupt(name)`.
  - Telegraph/attack-style enemy states extend `StateEnemyAnimated`.
- **Enemies:**
  - They path on the navmesh baked by `Scripts/World/EnemyNavigation.gd` (`Enemy.pathDirectionTo`, `walkingDistanceTo`, `hasLineOfSightTo`, `hasClearShot`).
  - They stay idle until their `Room` wakes up.
- **World objects:** `WorldObject` (an AnimatedSprite2D) plus `Property*` child nodes for behavior: `PropertyInteractable`, `PropertyCollidable` (also a navmesh obstacle), `PropertyWhippable`, `PropertyDetectingPlayer`.
- **Rooms:** `Room` nodes under `2DObjects/Rooms`. A room's name must match its sprite in the pause menu map.
- **Doors:** `Door` (interact, optionally locked) and `DoorTrigger` (driven by signals).
- **Enemy waves:** `EnemySpawner` and `EnemyCounter`.
- **Items:** add the id to `GlobalConstants.ItemIndices`, create a `.tres` in `Resources/Items` (`ItemData`), and register it in `ItemDatabase`. `ItemData.useState` is the player state a quick slot enters.
- **Physics layers:** use `PhysicsLayers` constants, not magic numbers. World objects' static bodies currently sit on the PLAYER layer.

## Conventions

- **Indentation:** tabs.
- **Names:**
  - `camelCase` for functions, variables and signals; a leading `_` for private ones.
  - `PascalCase` for `class_name` and nodes; `UPPER_SNAKE` for constants.
  - Some older exports use UPPERCASE (`SPEED`, `ATTACK_DELAY`); keep them as they are.
- **Comments:** `##` doc comments on classes, exports and public functions, explaining why rather than what. Match the comment density of the surrounding code.
- **Enums are stored as numbers in scenes** (e.g. a chest's `containingItem = 3`). Only append to enums like `ItemIndices`; never reorder or insert.
- **Commit the generated `.uid` files** of new scripts.
- **When editing `.tscn` files by hand:** keep `load_steps` and the ext_resource ids consistent, and prefer editing in Godot for anything visual.

## Workflow

- For features, explain the approach and get approval first.
- Then work on a new branch named `feature/<name>` (or `docs/`, `refactor/`), and commit there.
- Don't push, merge or open PRs unless asked.
- **Commit messages:** an imperative summary line, then a short body explaining what changed and why.
