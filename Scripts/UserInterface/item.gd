class_name Item extends TextureRect

@export var id: MenuGlobals.ItemIndices
@export var itemName: String
@export var description: String
@export var itemAmount: int = 0

func setItemTexture(iconTexture: Texture2D):
	$ItemIcon.texture = iconTexture

func setBackgroundTexture(bgTexture: Texture2D):
	self.texture = bgTexture

func addItemAmount(amount: int):
	itemAmount += amount
	$MarginContainer/ItemCount.text = str(itemAmount)

func _ready() -> void:
	$MarginContainer/ItemName.text = itemName

func _process(delta: float) -> void:
	pass
