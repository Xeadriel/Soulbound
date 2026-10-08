class_name Item extends TextureRect
## UI widget that shows one item: its icon, name and count.
## Icon and name come from the item's ItemData.

@export var id: GlobalConstants.ItemIndices:
	set(value):
		id = value
		if is_node_ready():
			refresh()
## Show the item's name below the icon (off for quick slots).
@export var showName : bool = true
@export var itemAmount: int = 0

func _ready() -> void:
	refresh()

## Updates icon and name from the item's ItemData.
func refresh() -> void:
	var data := ItemDatabase.getItem(id)
	texture = data.icon if data != null else null
	$MarginContainer/ItemName.text = data.displayName if data != null and showName else ""

func setItemAmount(amount: int) -> void:
	itemAmount = amount
	$MarginContainer/ItemCount.text = str(itemAmount)
