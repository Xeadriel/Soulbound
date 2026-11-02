class_name Goblin extends Enemy

@export var SPEED := 50

func attack() -> void:
	meleeHitboxes.enable(facing)
