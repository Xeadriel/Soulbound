class_name StateEnemy extends State

@export var entity: Enemy = null

enum inRangeBehavior {ATK, CIRCLE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(entity != null, "Entity should not be null")
	assert(owner is Enemy, "StateEnemy Class belongs only to Enemy class!")

func enter(_previous_state_path: String, _data := {}):
	pass
