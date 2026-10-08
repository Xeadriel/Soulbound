class_name PropertyWhippable extends PropertyItemReactive
## PropertyItemReactive preset for the whip.

signal gotWhipped(playerIndex: int)

func _init() -> void:
	reactsTo = [GlobalConstants.ItemIndices.WHIP]

func _ready() -> void:
	triggered.connect(gotWhipped.emit)
