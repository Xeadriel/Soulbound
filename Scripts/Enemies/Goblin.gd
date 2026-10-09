class_name Goblin extends Enemy

@export var SPEED := 100

func attack() -> void:
	meleeHitboxes.enable(facing)
	playDirectional("attack")
