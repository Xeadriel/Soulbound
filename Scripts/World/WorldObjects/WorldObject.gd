class_name WorldObject extends AnimatedSprite2D

# check which traits (destructible, interactible, obstacle etc.) are assigned
func _ready() -> void:
	pass 

func appear():
	visible = true
	# add some particles here
	process_mode = Node.PROCESS_MODE_INHERIT
