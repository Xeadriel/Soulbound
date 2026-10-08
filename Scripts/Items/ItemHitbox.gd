class_name ItemHitbox extends Area2D
## The hitting part of an item (e.g. the tip of the whip). Things that react to items
## (enemies via Enemy.onItemHit, world objects via PropertyItemReactive) check which
## item hit them and who used it.

@export var item : GlobalConstants.ItemIndices = GlobalConstants.ItemIndices.NOTHING
## Index of the player who used the item.
var playerIndex : int = 0
