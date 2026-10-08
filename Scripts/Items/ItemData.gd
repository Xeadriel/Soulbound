class_name ItemData extends Resource
## Definition of one item type. Lives as a .tres file in Resources/Items and is
## looked up by id through ItemDatabase.

enum Category {
	## Progression items with unique behavior (whip, ...).
	KEY_ITEM,
	## Bottles that can hold potions, water and more later. Never used up.
	BOTTLE,
	## Small keys for locked doors inside a dungeon.
	DUNGEON_KEY,
	## Money.
	CURRENCY,
}

@export var id : GlobalConstants.ItemIndices
@export var displayName : String
@export_multiline var description : String
@export var icon : Texture2D
@export var category : Category
## Whether the item can be put into a quick slot.
@export var equippable : bool = false
## Player state entered when the item is used from a quick slot. Empty = no effect yet.
@export var useState : String = ""
