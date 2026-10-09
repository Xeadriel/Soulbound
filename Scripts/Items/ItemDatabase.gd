class_name ItemDatabase
## Looks up ItemData definitions by item id.
## To add an item: add it to GlobalConstants.ItemIndices, create its .tres in
## Resources/Items and register the path here.

const _ITEM_PATHS : Dictionary[GlobalConstants.ItemIndices, String] = {
	GlobalConstants.ItemIndices.WHIP: "res://Resources/Items/Whip.tres",
	GlobalConstants.ItemIndices.POTION: "res://Resources/Items/Potion.tres",
	GlobalConstants.ItemIndices.SMALL_KEY: "res://Resources/Items/SmallKey.tres",
	GlobalConstants.ItemIndices.PIECES_OF_EIGHT: "res://Resources/Items/PiecesOfEight.tres",
}

## Returns the definition of the item, or null for NOTHING / unknown ids.
static func getItem(id : GlobalConstants.ItemIndices) -> ItemData:
	if not _ITEM_PATHS.has(id):
		return null
	return load(_ITEM_PATHS[id])
