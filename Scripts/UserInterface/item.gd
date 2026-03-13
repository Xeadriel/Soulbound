class_name Item extends TextureRect

@export var id: GlobalConstants.ItemIndices
@export var itemName: String
@export var description: String
@export var itemAmount: int = 0


func setItemTexture(iconTexture: Texture2D):
	texture = iconTexture

func setBackgroundTexture(bgTexture: Texture2D):
	self.texture = bgTexture

func addItemAmount(amount: int):
	itemAmount += amount
	$MarginContainer/ItemCount.text = str(itemAmount)

func _ready() -> void:
	$MarginContainer/ItemName.text = itemName
