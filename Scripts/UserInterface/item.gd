class_name Item extends TextureRect

@export var id: MenuGlobals.ItemIndices
@export var itemName: String
@export var description: String
@export var itemAmount: int

func setItemTexture(iconTexture: Texture2D):
	$ItemIcon.texture = iconTexture

func setBackgroundTexture(bgTexture: Texture2D):
	self.texture = bgTexture

func setItemName(name: String):
	itemName = name
	$MarginContainer/ItemName.text = name

func setItemAmount(amount: int):
	itemAmount = amount
	$MarginContainer/ItemCount.text = str(amount)

func _ready() -> void:
	setItemTexture(preload("res://Assets/UI Pack OS/minimap_compass_future_s.png"))
	setBackgroundTexture(preload("res://Assets/UI Pack OS/panel_grey_bolts_detail_a.png"))

func _process(delta: float) -> void:
	pass
