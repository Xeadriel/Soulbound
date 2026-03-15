class_name Lever extends WorldObject

var leverState = false

# check which traits (destructible, interactible, obstacle etc.) are assigned
func _ready() -> void:
	pass 

func leverPulled() -> void:
	leverState = not leverState

