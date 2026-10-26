# Soulbound — project docs

Soulbound is a local two-player co-op, top-down action adventure in the style of the 2D Zelda games, made in Godot 4.4 (GDScript). Two hunters of the Hunter Order clear dungeons full of Severed, the monsters that the dead become in a world without a god of death.

## Contents

| File | What's in it |
|---|---|
| [story.md](story.md) | World, lore, the Severed, the chalice, the Hunter Order, ending ideas |
| [design/players.md](design/players.md) | The two player characters, combat, blocking, controls |
| [design/enemies.md](design/enemies.md) | Regular enemies: goblin, goblin wizard, elite wizard, ideas |
| [design/bosses.md](design/bosses.md) | Miniboss (Death High Priest) and the end boss draft |
| [design/items.md](design/items.md) | Whip, bottle, chalice and the item idea pool |
| [design/dungeon-1.md](design/dungeon-1.md) | The first dungeon (jungle goblin dungeon / tutorial) |
| [design/ui.md](design/ui.md) | Pause menu, inventory, quick slots, dungeon map |
| [open-questions.md](open-questions.md) | Everything still undecided, in one place |
| [archive/old-concepts-de.md](archive/old-concepts-de.md) | Earlier, abandoned game concepts (German) |

Concept sketches are in [images/](images/).

## How to write these docs

- **Status tags.** Every section says how settled it is:
  - **Decided**: agreed on; build it this way.
  - **Draft**: a worked-out proposal, still up for discussion.
  - **Idea**: brainstorming, nothing agreed.
  - **Open**: a question that needs a decision (also listed in [open-questions.md](open-questions.md)).
- **"Built" notes** say what already exists in the game, with links to the code. When design and code disagree, the note says so.
- **Use the names from the code** in backticks (`MiniBossDeathHighPriest`, `GameSession`), so design and code are easy to match.
- **Write it out.** Sketches are welcome, but the important content should also be in text (or a Mermaid diagram), so it is searchable and editable.
- **Keep ideas apart from decisions.** Brainstorm lists stay in their own sections; when something gets decided, move it and note why in one line.

These docs replace the old Word/text files in `Misc/` (`design.docx`, `Design.txt`, `Theme & Story.docx`, `Hauptidee - OLD.docx`). Their content was moved here as-is, only reorganized; the originals are in the git history.
