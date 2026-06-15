extends StateNamesMiniBossDeathHighPriest


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func process(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	print("telegraphing dagger cone")

func exit() -> void:
	pass

func animationFinished(animatedSprite: AnimatedSprite2D):
	pass
